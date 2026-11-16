#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Upgrades the Kubernetes cluster with kubespray's upgrade-cluster.yml playbook. Run it from its own folder. Takes no options."
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

# The Kubernetes version to upgrade to; it must be supported by the checked out Kubespray
KUBE_VERSION="1.34.3"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

CURRENT_DIR=${PWD}
REPO_ROOT=$(git rev-parse --show-toplevel)

if ! pushd kubespray-repo; then
  echo "ERROR: No kubespray-repo folder here, clone it first (see README)"
  exit 1
fi

CHECKSUMS_FILE="roles/kubespray_defaults/vars/main/checksums.yml"
if ! grep -q "^    ${KUBE_VERSION}:" "${CHECKSUMS_FILE}"; then
  echo "ERROR: The checked out Kubespray doesn't support Kubernetes ${KUBE_VERSION} (see ${CHECKSUMS_FILE})"
  exit 1
fi

"${REPO_ROOT}"/common-ansible-run-playbook.sh \
    --ansible-navigator-config "${REPO_ROOT}"/.ansible-navigator.yaml \
    --inventory "${CURRENT_DIR}"/inventory/hosts.yaml \
    --playbook "${CURRENT_DIR}"/kubespray-repo/upgrade-cluster.yml \
    --no-check \
    --extra-args "--become" \
    --extra-args "-e system_upgrade=true" \
    --extra-args "-e kube_version=${KUBE_VERSION}"

popd
