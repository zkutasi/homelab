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

JWT_SECRET=$(yq '.workload.main.podSpec.containers.main.env.JWT_SECRET' app-values-private.yaml)
if [[ "${JWT_SECRET}" == "null" ]]; then
  JWT_SECRET=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".workload.main.podSpec.containers.main.env.JWT_SECRET=\"${JWT_SECRET}\"" app-values-private.yaml
fi

kubectl create secret generic ca-certificates \
    --namespace $NS \
    --from-file=homelab-ca.pem=config/static/ca.crt \

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
