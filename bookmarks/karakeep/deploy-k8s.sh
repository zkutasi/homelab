#!/bin/bash

APP=karakeep
NS=karakeep
RELEASE_NAME=karakeep

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

if [ ! -f app-values-private.yaml ]; then
    touch app-values-private.yaml
fi

NEXTAUTH_SECRET=$(yq '.workload.main.podSpec.containers.main.env.NEXTAUTH_SECRET' app-values-private.yaml)
if [[ "${NEXTAUTH_SECRET}" == "null" ]]; then
    NEXTAUTH_SECRET=$(openssl rand -base64 36)
    yq -i ".workload.main.podSpec.containers.main.env.NEXTAUTH_SECRET=\"${NEXTAUTH_SECRET}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
