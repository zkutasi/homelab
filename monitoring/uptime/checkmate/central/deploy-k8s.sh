#!/bin/bash

APP=checkmate
NS=checkmate
RELEASE_NAME=checkmate

EXTRA_PARAMS=

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
    --from-file=homelab-ca.pem=config/static/ca.crt \
    --dry-run=client -o yaml | kubectl apply -f -

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
