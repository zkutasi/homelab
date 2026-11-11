#!/bin/bash

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

"${REPO_ROOT}"/common-ansible-run-playbook.sh \
    --ansible-navigator-config "${REPO_ROOT}"/.ansible-navigator.yaml \
    --inventory "${CURRENT_DIR}"/inventory/hosts.yaml \
    --playbook "${CURRENT_DIR}"/kubespray-repo/upgrade-cluster.yml \
    --no-check \
    --extra-args "--become" \
    --extra-args "-e system_upgrade=true" \
    --extra-args "-e kube_version=1.34.3"

popd
