#!/usr/bin/env bats
# kubernetes/k8s-install/kubespray/run-install.sh: runs Kubespray's cluster playbook from its own folder,
# and passes the playbook's exit code on

load helpers

KUBESPRAY=kubernetes/k8s-install/kubespray

setup() {
  setup_fake_repo
  copy_into_repo "${KUBESPRAY}/run-install.sh"
  SCRIPT_DIR="${FAKE_REPO}/${KUBESPRAY}"
  SCRIPT="${SCRIPT_DIR}/run-install.sh"
  mkdir -p "${SCRIPT_DIR}/kubespray-repo"
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh"
  cd "${SCRIPT_DIR}" || exit 1
}

@test "it runs the cluster playbook for real, with become" {
  run ./run-install.sh
  assert_success
  assert_stub_called "common-ansible-run-playbook.sh --ansible-navigator-config ${FAKE_REPO}/.ansible-navigator.yaml --inventory ${SCRIPT_DIR}/inventory/hosts.yaml --playbook ${SCRIPT_DIR}/kubespray-repo/cluster.yml --no-check --extra-args --become"
}

@test "a failed cluster playbook is reported through the exit code" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh" 2
  run ./run-install.sh
  assert_failure 2
}

@test "it refuses to run from another folder" {
  cd "${FAKE_REPO}" || exit 1
  run "${SCRIPT}"
  assert_failure 1
  assert_output --partial "ERROR: Run run-install.sh from its own folder"
  assert_stub_not_called common-ansible-run-playbook.sh
}

@test "it refuses to run without a kubespray-repo clone" {
  rm -rf "${SCRIPT_DIR}/kubespray-repo"
  run ./run-install.sh
  assert_failure 1
  assert_output --partial "ERROR: No kubespray-repo folder here"
}
