#!/usr/bin/env bats
# common-ansible-run-playbook.sh: builds the ansible-navigator (or ansible-playbook) command line,
# in check and diff mode unless told otherwise, and passes the playbook's exit code on
# covers: common-ansible-run-playbook.sh

load helpers

setup() {
  setup_fake_repo
  copy_into_repo common-ansible-run-playbook.sh
  RUNNER="${FAKE_REPO}/common-ansible-run-playbook.sh"
  INVENTORY="${FAKE_REPO}/automation/ansible/homelab-ansible-inventory/inventory"
  cd "${FAKE_REPO}" || exit 1
}

# The navigator stub logs the two configuration variables the runner sets up
function make_navigator() {
  STUB_ENV_VARS="ANSIBLE_CONFIG ANSIBLE_NAVIGATOR_CONFIG" make_stub ansible-navigator "${1:-0}"
}

# --- usage and option errors ---

@test "--help prints the usage and succeeds" {
  run "${RUNNER}" --help
  assert_success
  assert_output --partial "Usage:"
}

@test "an unknown option is refused with the usage" {
  run "${RUNNER}" --playbook site.yaml --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
  assert_output --partial "Usage:"
}

@test "without --playbook it refuses to run" {
  make_navigator
  run "${RUNNER}"
  assert_failure 1
  assert_output --partial "ERROR: No playbook specified"
  assert_stub_not_called ansible-navigator
}

@test "options that need a value refuse a missing value" {
  local option
  for option in --playbook --inventory --limit --ansible-navigator-config; do
    run "${RUNNER}" "${option}"
    assert_failure 1
    assert_output --partial "ERROR: ${option} needs a value"
  done
}

@test "options that need a value refuse the next option as their value" {
  run "${RUNNER}" --playbook site.yaml --limit --no-check
  assert_failure 1
  assert_output --partial "ERROR: --limit needs a value"
}

@test "--extra-args refuses a missing value, but takes a value that starts with --" {
  run "${RUNNER}" --playbook site.yaml --extra-args
  assert_failure 1
  assert_output --partial "ERROR: --extra-args needs a value"

  make_navigator
  run "${RUNNER}" --playbook site.yaml --extra-args --become
  assert_success
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --become --check --diff"
}

# --- the command line ---

@test "by default it runs ansible-navigator on the repo inventory in check and diff mode" {
  make_navigator
  run "${RUNNER}" --playbook site.yaml
  assert_success
  assert_output --partial "Using ansible-navigator..."
  assert_output --partial "Executing command: ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --check --diff"
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --check --diff"
}

@test "--no-check and --no-diff drop their flags" {
  make_navigator
  run "${RUNNER}" --playbook site.yaml --no-check
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --diff"

  : > "${STUB_LOG}"
  run "${RUNNER}" --playbook site.yaml --no-diff
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --check"

  : > "${STUB_LOG}"
  run "${RUNNER}" --no-check --no-diff --playbook site.yaml
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY}"
}

@test "--limit and --inventory are passed on" {
  make_navigator
  run "${RUNNER}" --playbook site.yaml --inventory /other/inventory --limit "web:&docker"
  assert_success
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory /other/inventory --check --diff --limit web:\\&docker"
}

@test "--extra-args are collected in order and split into words" {
  make_navigator
  run "${RUNNER}" --playbook site.yaml --extra-args "--become" --extra-args "-e system_upgrade=true" --extra-args "-e kube_version=1.34.3"
  assert_success
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} --become -e system_upgrade=true -e kube_version=1.34.3 --check --diff"
}

@test "--extra-args words are not expanded as file name patterns" {
  touch "${FAKE_REPO}/tags=match-me"
  make_navigator
  run "${RUNNER}" --playbook site.yaml --extra-args "-e tags=*"
  assert_success
  assert_stub_called "ansible-navigator run site.yaml -m stdout --inventory ${INVENTORY} -e tags=\\* --check --diff"
}

@test "a playbook path with spaces stays one argument" {
  make_navigator
  run "${RUNNER}" --playbook "my plays/site.yaml"
  assert_success
  assert_stub_called "ansible-navigator run my\\ plays/site.yaml -m stdout --inventory ${INVENTORY} --check --diff"
}

# --- configuration handed to Ansible ---

@test "the repo's navigator config is exported, unless another one is given" {
  make_navigator
  run "${RUNNER}" --playbook site.yaml
  assert_stub_called "ANSIBLE_NAVIGATOR_CONFIG=${FAKE_REPO}/.ansible-navigator.yaml"

  : > "${STUB_LOG}"
  run "${RUNNER}" --playbook site.yaml --ansible-navigator-config /elsewhere/navigator.yaml
  assert_stub_called "ANSIBLE_NAVIGATOR_CONFIG=/elsewhere/navigator.yaml"
}

@test "the repo's ansible.cfg is exported, from any folder of the repo" {
  make_navigator
  mkdir -p "${FAKE_REPO}/some/folder"
  cd "${FAKE_REPO}/some/folder" || exit 1
  run "${RUNNER}" --playbook site.yaml
  assert_success
  assert_stub_called "ANSIBLE_CONFIG=${FAKE_REPO}/ansible.cfg"
}

@test "an ansible.cfg in the current folder wins over the repo's" {
  make_navigator
  mkdir -p "${FAKE_REPO}/kubespray-repo"
  touch "${FAKE_REPO}/kubespray-repo/ansible.cfg"
  cd "${FAKE_REPO}/kubespray-repo" || exit 1
  run env -u ANSIBLE_CONFIG "${RUNNER}" --playbook site.yaml
  assert_success
  assert_stub_called "ANSIBLE_CONFIG unset"
}

# --- which Ansible runs, and its exit code ---

@test "without ansible-navigator it falls back to ansible-playbook" {
  make_stub ansible
  make_stub ansible-playbook
  run "${RUNNER}" --playbook site.yaml --limit web --extra-args "-e x=1"
  assert_success
  assert_output --partial "Using ansible-playbook..."
  assert_stub_called "ansible-playbook --inventory ${INVENTORY} site.yaml -e x=1 --check --diff --limit web"
}

@test "with neither ansible-navigator nor ansible it fails" {
  run "${RUNNER}" --playbook site.yaml
  assert_failure 1
  assert_output --partial "ERROR: neither ansible-navigator nor ansible-playbook is available"
}

@test "the playbook's exit code is passed on" {
  make_navigator 4
  run "${RUNNER}" --playbook site.yaml
  assert_failure 4
}
