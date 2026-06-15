#!/bin/bash

CHART_NAME=oci://ghcr.io/renovatebot/charts/renovate
NS=renovate
RELEASE_NAME=renovate
VERSION=46.187.0

EXTRA_PARAMS="--extra-values app-values-config-private.yaml"

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
