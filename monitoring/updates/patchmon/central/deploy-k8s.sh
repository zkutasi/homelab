#!/bin/bash

APP=patchmon
NS=patchmon
RELEASE_NAME=patchmon

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

REDIS_PASSWORD=$(yq '.redis.password' app-values-private.yaml)
if [[ "${REDIS_PASSWORD}" == "null" ]]; then
    REDIS_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"
    yq -i ".redis.password=\"${REDIS_PASSWORD}\"" app-values-private.yaml
    yq -i ".workload.main.podSpec.containers.backend.env.REDIS_PASSWORD=\"${REDIS_PASSWORD}\"" app-values-private.yaml
fi

DB_PASSWORD=$(yq '.cnpg.main.password' app-values-private.yaml)
if [[ "${DB_PASSWORD}" == "null" ]]; then
    DB_PASSWORD="$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)"
    yq -i ".cnpg.main.password=\"${DB_PASSWORD}\"" app-values-private.yaml
    yq -i ".workload.main.podSpec.containers.backend.env.DB_PASSWORD=\"${DB_PASSWORD}\"" app-values-private.yaml
fi

JWT_SECRET=$(yq '.workload.main.podSpec.containers.backend.env.JWT_SECRET' app-values-private.yaml)
if [[ "${JWT_SECRET}" == "null" ]]; then
    JWT_SECRET="$(openssl rand -hex 64)"
    yq -i ".workload.main.podSpec.containers.backend.env.JWT_SECRET=\"${JWT_SECRET}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
