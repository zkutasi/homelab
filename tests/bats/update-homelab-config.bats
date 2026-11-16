#!/usr/bin/env bats
# update-homelab-config.sh: applies the config playbook for real, then redeploys Gatus, but only if the
# playbook succeeded (item 187)

load helpers

setup() {
  setup_fake_repo
  copy_into_repo update-homelab-config.sh
  SCRIPT="${FAKE_REPO}/update-homelab-config.sh"
  GATUS_DIR="${FAKE_REPO}/monitoring/uptime/gatus/central"
  STUB_ENV_VARS="PWD" write_stub "${GATUS_DIR}/deploy-k8s.sh"
  cd "${FAKE_REPO}" || exit 1
}

@test "--help prints the usage and succeeds" {
  run "${SCRIPT}" --help
  assert_success
  assert_output --partial "Usage:"
}

@test "an unknown option is refused" {
  run "${SCRIPT}" --bogus
  assert_failure 1
  assert_output --partial 'ERROR: unknown parameter "--bogus"'
}

@test "the config playbook runs for real, then Gatus is redeployed from its own folder" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh"
  run "${SCRIPT}"
  assert_success
  assert_stub_called "common-ansible-run-playbook.sh --playbook ${FAKE_REPO}/update-homelab-config.yaml --no-check"
  assert_stub_called "deploy-k8s.sh"
  assert_stub_called "PWD=${GATUS_DIR}"
}

@test "a failed config playbook stops before Gatus and passes its exit code on" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh" 3
  run "${SCRIPT}"
  assert_failure 3
  assert_output --partial "ERROR: the config playbook failed, Gatus is not redeployed"
  assert_stub_not_called deploy-k8s.sh
}

@test "a failed Gatus deploy is reported through the exit code" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh"
  write_stub "${GATUS_DIR}/deploy-k8s.sh" 5
  run "${SCRIPT}"
  assert_failure 5
}

@test "it works from any folder of the repository" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh"
  mkdir -p "${FAKE_REPO}/somewhere/else"
  cd "${FAKE_REPO}/somewhere/else" || exit 1
  run "${SCRIPT}"
  assert_success
  assert_stub_called "PWD=${GATUS_DIR}"
}
