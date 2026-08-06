#!/bin/bash

CHART_NAME=oci://quay.io/enix/charts/x509-certificate-exporter
NS=x509-certificate-exporter
RELEASE_NAME=x509-certificate-exporter
VERSION=4.1.0

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
