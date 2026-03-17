#!/bin/bash

CHART_NAME=external-dns/external-dns
NS=external-dns
RELEASE_NAME=external-dns
REPO_URL=https://kubernetes-sigs.github.io/external-dns/
VERSION=1.16.1

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
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
