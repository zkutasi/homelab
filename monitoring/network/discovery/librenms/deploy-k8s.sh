#!/bin/bash

CHART_NAME=librenms/librenms
NS=librenms
RELEASE_NAME=librenms
REPO_URL=https://librenms.github.io/helm-charts

EXTRA_PARAMS="--post-renderer kustomize.sh"

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
