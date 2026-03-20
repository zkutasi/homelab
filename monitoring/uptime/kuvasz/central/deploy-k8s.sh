#!/bin/bash

APP=kuvasz
CHART_NAME=oci://ghcr.io/kuvasz-uptime/kuvasz-uptime
NS=kuvasz
RELEASE_NAME=kuvasz
VERSION=3.5.1

EXTRA_PARAMS="--extra-values app-values-config-private.yaml"

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

kubectl create secret generic ca-certificates \
    --namespace $NS \
    --from-file=cacerts=config/static/cacerts \

$(git rev-parse --show-toplevel)/common-ansible-run-playbook.sh \
    --playbook ${PWD}/generate-configuration.yaml \
    --no-check

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
