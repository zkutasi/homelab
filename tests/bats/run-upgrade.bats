#!/usr/bin/env bats
# kubernetes/k8s-install/kubespray/run-upgrade.sh: runs Kubespray's upgrade playbook for the pinned
# KUBE_VERSION, but only from its own folder and only if the checked-out Kubespray supports that version
# covers: kubernetes/k8s-install/kubespray/run-upgrade.sh

load helpers

KUBESPRAY=kubernetes/k8s-install/kubespray

setup() {
  setup_fake_repo
  copy_into_repo "${KUBESPRAY}/run-upgrade.sh"
  SCRIPT_DIR="${FAKE_REPO}/${KUBESPRAY}"
  SCRIPT="${SCRIPT_DIR}/run-upgrade.sh"
  KUBE_VERSION=$(sed -n 's/^KUBE_VERSION="\(.*\)"$/\1/p' "${SCRIPT}")
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh"
  CHECKSUMS="${SCRIPT_DIR}/kubespray-repo/roles/kubespray_defaults/vars/main/checksums.yml"
  mkdir -p "$(dirname "${CHECKSUMS}")"
  printf 'kubelet_checksums:\n  amd64:\n    %s: sha256:0000\n    1.33.7: sha256:1111\n' "${KUBE_VERSION}" > "${CHECKSUMS}"
  cd "${SCRIPT_DIR}" || exit 1
}

# set_kube_version <version>: changes the pinned version in the fake repository's copy of the script
function set_kube_version() {
  sed -i "s/^KUBE_VERSION=.*/KUBE_VERSION=\"$1\"/" "${SCRIPT}"
}

@test "the pinned KUBE_VERSION is a full x.y.z version" {
  assert_regex "${KUBE_VERSION}" '^[0-9]+\.[0-9]+\.[0-9]+$'
}

@test "a supported version runs the upgrade playbook with it" {
  run ./run-upgrade.sh
  assert_success
  assert_stub_called "common-ansible-run-playbook.sh --ansible-navigator-config ${FAKE_REPO}/.ansible-navigator.yaml --inventory ${SCRIPT_DIR}/inventory/hosts.yaml --playbook ${SCRIPT_DIR}/kubespray-repo/upgrade-cluster.yml --no-check --extra-args --become --extra-args -e\\ system_upgrade=true --extra-args -e\\ kube_version=${KUBE_VERSION}"
}

@test "an unsupported version stops before the playbook" {
  set_kube_version 1.99.0
  run ./run-upgrade.sh
  assert_failure 1
  assert_output --partial "ERROR: The checked out Kubespray doesn't support Kubernetes 1.99.0"
  assert_stub_not_called common-ansible-run-playbook.sh
}

@test "an incomplete version stops before the playbook" {
  set_kube_version 1.33
  run ./run-upgrade.sh
  assert_failure 1
  assert_output --partial "doesn't support Kubernetes 1.33"
  assert_stub_not_called common-ansible-run-playbook.sh
}

@test "it refuses to run from another folder" {
  cd "${FAKE_REPO}" || exit 1
  run "${SCRIPT}"
  assert_failure 1
  assert_output --partial "ERROR: Run run-upgrade.sh from its own folder"
  assert_stub_not_called common-ansible-run-playbook.sh
}

@test "it refuses to run without a kubespray-repo clone" {
  rm -rf "${SCRIPT_DIR}/kubespray-repo"
  run ./run-upgrade.sh
  assert_failure 1
  assert_output --partial "ERROR: No kubespray-repo folder here"
}

@test "a failed upgrade playbook is reported through the exit code" {
  write_stub "${FAKE_REPO}/common-ansible-run-playbook.sh" 2
  run ./run-upgrade.sh
  assert_failure 2
}
