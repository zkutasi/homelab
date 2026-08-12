#!/bin/bash

CHART_NAME=giantswarm/silence-operator
NS=silence-operator
RELEASE_NAME=silence-operator
REPO_URL=https://giantswarm.github.io/control-plane-catalog/
VERSION=0.20.1

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
