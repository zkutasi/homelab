#!/usr/bin/env bats
# automation/ansible/deploy-ansible.sh: installs the pinned ansible-navigator and ansible-builder with pipx,
# then builds the execution environment image

load helpers

setup() {
  setup_fake_repo
  copy_into_repo automation/ansible/deploy-ansible.sh
  SCRIPT="${FAKE_REPO}/automation/ansible/deploy-ansible.sh"
  NAVIGATOR_VERSION=$(sed -n 's/^NAVIGATOR_VERSION="\(.*\)"$/\1/p' "${SCRIPT}")
  BUILDER_VERSION=$(sed -n 's/^BUILDER_VERSION="\(.*\)"$/\1/p' "${SCRIPT}")
  make_stub sudo
  make_stub pipx
  make_stub ansible-builder
  cd "${FAKE_REPO}" || exit 1
}

@test "both tools are pinned with a Renovate annotation" {
  assert_regex "${NAVIGATOR_VERSION}" '^[0-9]+\.[0-9]+\.[0-9]+$'
  assert_regex "${BUILDER_VERSION}" '^[0-9]+\.[0-9]+\.[0-9]+$'
  run grep -B1 -E '^(NAVIGATOR|BUILDER)_VERSION=' "${SCRIPT}"
  assert_line "# renovate: datasource=pypi depName=ansible-navigator"
  assert_line "# renovate: datasource=pypi depName=ansible-builder"
}

@test "it installs the pinned versions, forced so a changed pin is applied, then builds the EE" {
  run "${SCRIPT}"
  assert_success
  run cat "${STUB_LOG}"
  assert_output "sudo apt-get install -y pipx
pipx install --force ansible-navigator==${NAVIGATOR_VERSION}
pipx install --force ansible-builder==${BUILDER_VERSION}
ansible-builder build -vvv -f ${FAKE_REPO}/automation/ansible/ansible-execution-environment/execution-environment.yaml --context ${FAKE_REPO}/automation/ansible/ansible-execution-environment/context -t ansible-execution-environment:latest"
}

@test "a failed build is reported through the exit code" {
  make_stub ansible-builder 7
  run "${SCRIPT}"
  assert_failure 7
}

@test "an unknown option is refused before anything is installed" {
  run "${SCRIPT}" --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
  assert_stub_not_called sudo
}
