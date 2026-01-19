#!/bin/bash

CA_DIR=$(git rev-parse --show-toplevel)/security/certificates/certs/
CHART_NAME=jetstack/cert-manager
NS=cert-manager
RELEASE_NAME=cert-manager
REPO_URL=https://charts.jetstack.io

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --repo-url "${REPO_URL}" \
    ${EXTRA_PARAMS}

kubectl create secret generic contour-internal-ca-secret \
    --namespace cert-manager \
    --from-file=tls.key=${CA_DIR}/ca.key \
    --from-file=tls.crt=${CA_DIR}/ca.crt
