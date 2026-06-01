#!/bin/bash

CHART_NAME=oci://ghcr.io/portabase/charts/portabase
NS=portabase
RELEASE_NAME=portabase
VERSION=1.13.0

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

PROJECT_SECRET=$(yq '.project.secret' app-values-private.yaml)
if [[ "${PROJECT_SECRET}" == "null" ]]; then
    PROJECT_SECRET=$(openssl rand -base64 36)
    yq -i ".project.secret=\"${PROJECT_SECRET}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
