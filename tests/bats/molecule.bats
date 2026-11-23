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
  mkdir -p "${FAKE_REPO}/tests/molecule/images/debian-12" "${FAKE_REPO}/tests/molecule/images/ubuntu-24.04"
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
  for harness in tests/molecule/config.yml tests/molecule/images/debian-12/Dockerfile \
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

@test "the targets are built, then each role's scenarios run in the execution environment with the Docker socket" {
  run "${RUNNER}" tool-install
  assert_success
  assert_stub_called "docker build -q -t homelab-molecule:debian-12 ${FAKE_REPO}/tests/molecule/images/debian-12/"
  assert_stub_called "docker build -q -t homelab-molecule:ubuntu-24.04 ${FAKE_REPO}/tests/molecule/images/ubuntu-24.04/"
  run grep -c "^docker run --rm --user [0-9]*:[0-9]* --group-add 999 .* -v /var/run/docker.sock:/var/run/docker.sock .* -w /code/automation/ansible/roles/tool-install --entrypoint molecule ee:latest -c /code/tests/molecule/config.yml test --all$" "${STUB_LOG}"
  assert_output "1"
}

@test "a failing role doesn't stop the others, and the run fails naming it" {
  make_stub_script docker '[[ " $* " == *" -w /code/automation/ansible/roles/tool-install "* ]] && exit 2; exit 0'
  run "${RUNNER}"
  assert_failure 1
  assert_line "INFO: Testing tool-remove..."
  assert_line "ERROR: Molecule failed for: tool-install"
}
