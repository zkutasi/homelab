#!/bin/bash

APP=kuvasz
CHART_NAME=oci://ghcr.io/kuvasz-uptime/kuvasz-uptime
NS=kuvasz
RELEASE_NAME=kuvasz
VERSION=3.5.1

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-cnpg.sh \
    --app-user ${APP} \
    --namespace $NS \
    ${EXTRA_PARAMS}

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
