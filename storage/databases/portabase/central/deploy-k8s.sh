#!/bin/bash

CHART_NAME=oci://ghcr.io/portabase/charts/portabase
NS=portabase
RELEASE_NAME=portabase
VERSION=1.22.2

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
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
