#!/bin/bash

CHART_NAME=sstarcher/helm-exporter
NS=helm-exporter
RELEASE_NAME=helm-exporter
REPO_URL=https://shanestarcher.com/helm-charts/
VERSION=1.3.0

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
