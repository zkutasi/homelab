#!/bin/bash

APP=portabase-agent
NS=portabase
RELEASE_NAME=portabase-agent

EXTRA_PARAMS="--extra-values app-values-config-private.yaml"

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

kubectl create secret generic ca-certificates \
    --namespace $NS \
    --from-file=homelab-ca.crt=config/static/ca.crt \
    --dry-run=client -o yaml | kubectl apply -f -

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
