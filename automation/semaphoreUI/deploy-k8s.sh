#!/bin/bash

CHART_NAME=semaphoreui/semaphore
NS=semaphore
RELEASE_NAME=semaphore
REPO_URL=https://semaphoreui.github.io/charts

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
