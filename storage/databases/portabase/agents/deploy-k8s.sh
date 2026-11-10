#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

CA_DIR=$(git rev-parse --show-toplevel)/security/certificates/certs/
APP=portabase-agent
NS=portabase
RELEASE_NAME=portabase-agent

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

kubectl create secret generic ca-certificates \
    --namespace $NS \
    --from-file=homelab-ca.crt="${CA_DIR}"/ca.crt \
    --dry-run=client -o yaml | kubectl apply -f -

"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name "${PWD}"/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
