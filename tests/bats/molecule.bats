#!/usr/bin/env bats
# tests/molecule/molecule.sh: picks the roles to test and runs their scenarios in the execution environment
# covers: tests/molecule/molecule.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo tests/molecule/molecule.sh
  RUNNER="${FAKE_REPO}/tests/molecule/molecule.sh"
  ROLES="${FAKE_REPO}/automation/ansible/roles"
  # Two tested roles, the second one installing the first in its prepare, and a role without scenarios
  mkdir -p "${ROLES}/tool-install/molecule/default" "${ROLES}/tool-remove/molecule/default" "${ROLES}/other/tasks"
  printf -- '- name: Install\n  ansible.builtin.include_role:\n    name: tool-install\n' \
    > "${ROLES}/tool-remove/molecule/default/prepare.yml"
  printf -- '- name: Case\n  roles:\n    - tool-remove\n' > "${ROLES}/tool-remove/molecule/default/converge.yml"
  echo "FROM ubuntu:24.04" > "${FAKE_REPO}/tests/molecule/Dockerfile"
  DOCKERFILE_HASH=$(sha256sum "${FAKE_REPO}/tests/molecule/Dockerfile" | cut -c1-16)
  printf 'ansible-navigator:\n  execution-environment:\n    image: ee:latest\n' > "${FAKE_REPO}/.ansible-navigator.yaml"
  make_stub docker
  make_stub stat 0 999
  cd "${FAKE_REPO}" || exit 1
}

@test "without arguments, every role with scenarios is tested" {
  run "${RUNNER}" --list
  assert_success
  assert_output "tool-install
tool-remove"
}

@test "a changed role selects itself and the roles whose scenarios use it" {
  run "${RUNNER}" --list --changed automation/ansible/roles/tool-install/tasks/main.yaml README.md
  assert_success
  assert_output "tool-install
tool-remove"
  run "${RUNNER}" --list --changed automation/ansible/roles/tool-remove/tasks/main.yaml
  assert_success
  assert_output "tool-remove"
}

@test "a change to the harness or the execution environment selects every role" {
  local harness
  for harness in tests/molecule/config.yml tests/molecule/Dockerfile \
      automation/ansible/ansible-execution-environment/execution-environment.yaml; do
    run "${RUNNER}" --list --changed "${harness}"
    assert_success
    assert_output "tool-install
tool-remove"
  done
}

@test "when no scenario covers the changes, no container is started" {
  run "${RUNNER}" --changed automation/ansible/roles/other/tasks/main.yaml README.md
  assert_success
  assert_output "INFO: No Molecule scenario covers the changed files"
  assert_stub_not_called docker
}

@test "a role without scenarios is refused" {
  run "${RUNNER}" other
  assert_failure 1
  assert_output "ERROR: role other has no Molecule scenarios"
}

# docker_answering <label> <old id> <new id>: a docker stub whose image has the given Dockerfile label ("" for no
# image) and ID, and the new ID once it was built
function docker_answering() {
  make_stub_script docker "
    case \"\$1 \$2\" in
      'image inspect')
        if [ -e '${BATS_TEST_TMPDIR}/built' ]; then echo '$3'; exit 0; fi
        [ -z '$1' ] && exit 1
        [[ \"\$*\" == *Labels* ]] && echo '$1' || echo '$2'
        ;;
      'build -q') touch '${BATS_TEST_TMPDIR}/built' ;;
    esac
    exit 0"
}

@test "without the image, the target is built with its Dockerfile's hash, then each role's scenarios run" {
  docker_answering "" "" sha256:new
  run "${RUNNER}" tool-install
  assert_success
  assert_line "INFO: Building homelab-molecule:testing..."
  assert_stub_called "docker build -q --target base --label homelab.dockerfile=${DOCKERFILE_HASH} -t homelab-molecule:testing -"
  run grep -c "^docker rmi" "${STUB_LOG}"
  assert_output "0"
  run grep -c "^docker run --rm --user [0-9]*:[0-9]* --group-add 999 .* -v /var/run/docker.sock:/var/run/docker.sock .* -w /code/automation/ansible/roles/tool-install --entrypoint molecule ee:latest -c /code/tests/molecule/config.yml test --all$" "${STUB_LOG}"
  assert_output "1"
}

@test "an image built from the same Dockerfile is reused" {
  docker_answering "${DOCKERFILE_HASH}" sha256:old sha256:new
  run "${RUNNER}" tool-install
  assert_success
  refute_line "INFO: Building homelab-molecule:testing..."
  run grep -c "^docker build" "${STUB_LOG}"
  assert_output "0"
}

@test "a changed Dockerfile rebuilds the target and removes the replaced image" {
  docker_answering 0123456789abcdef sha256:old sha256:new
  run "${RUNNER}" tool-install
  assert_success
  assert_stub_called "docker rmi sha256:old"
}

@test "a rebuild that yields the same image keeps it" {
  docker_answering 0123456789abcdef sha256:same sha256:same
  run "${RUNNER}" tool-install
  assert_success
  run grep -c "^docker rmi" "${STUB_LOG}"
  assert_output "0"
}

@test "the Docker target is built only when a selected role's scenarios use it" {
  docker_answering "" "" sha256:new
  run "${RUNNER}" tool-install
  assert_success
  run grep -c "^docker build .* --target docker " "${STUB_LOG}"
  assert_output "0"
  echo "    image: homelab-molecule-docker:testing" > "${ROLES}/tool-remove/molecule/default/molecule.yml"
  rm -f "${BATS_TEST_TMPDIR}/built"
  run "${RUNNER}" tool-install tool-remove
  assert_success
  assert_stub_called "docker build -q --target docker --label homelab.dockerfile=${DOCKERFILE_HASH} -t homelab-molecule-docker:testing -"
}

@test "a failing role doesn't stop the others, and the run fails naming it" {
  make_stub_script docker '[[ " $* " == *" -w /code/automation/ansible/roles/tool-install "* ]] && exit 2; exit 0'
  run "${RUNNER}"
  assert_failure 1
  assert_line "INFO: Testing tool-remove..."
  assert_line "ERROR: Molecule failed for: tool-install"
}

@test "--keep leaves the targets and stops at the first failed role" {
  make_stub_script docker '[[ " $* " == *" -w /code/automation/ansible/roles/tool-install "* ]] && exit 2; exit 0'
  run "${RUNNER}" --keep
  assert_failure 1
  assert_line --partial "Kept the target of tool-install's failed scenario"
  refute_line "INFO: Testing tool-remove..."
  run grep -c -- "test --all --destroy=never$" "${STUB_LOG}"
  assert_output "1"
}
