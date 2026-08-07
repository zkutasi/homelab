#!/bin/bash

CHART_NAME=k8s-ephemeral-storage-metrics/k8s-ephemeral-storage-metrics
NS=k8s-ephemeral-storage-metrics
RELEASE_NAME=k8s-ephemeral-storage-metrics
REPO_URL=https://jmcgrath207.github.io/k8s-ephemeral-storage-metrics/chart
VERSION=1.21.3

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
