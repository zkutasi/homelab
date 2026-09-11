#!/bin/bash

CHART_NAME=oci://oci.trueforge.org/truecharts/shiori
NS=shiori
RELEASE_NAME=shiori
VERSION=19.14.11

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
    --namespace "${NS}" \
    --release-name "${RELEASE_NAME}" \
    --type truecharts \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
