#!/bin/bash

CURRENT_DIR=${PWD}
REPO_ROOT=$(git rev-parse --show-toplevel)

pushd kubespray-repo

${REPO_ROOT}/common-ansible-run-playbook.sh \
    --ansible-navigator-config ${REPO_ROOT}/.ansible-navigator.yaml \
    --inventory ${CURRENT_DIR}/inventory/hosts.yaml \
    --playbook ${CURRENT_DIR}/kubespray-repo/upgrade-cluster.yml \
    --no-check \
    --extra-args "--become" \
    --extra-args "-e system_upgrade=true" \
    --extra-args "-e kube_version=1.34.3"

popd
