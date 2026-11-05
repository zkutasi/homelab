#!/bin/bash

CHART_NAME=<APP_NAME_LOWERCASE>/<APP_NAME_LOWERCASE>
NS=<APP_NAME_LOWERCASE>
RELEASE_NAME=<APP_NAME_LOWERCASE>
REPO_URL=XXX
VERSION=<APP_VERSION>

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --repo-url "${REPO_URL}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
