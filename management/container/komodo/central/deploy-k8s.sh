#!/bin/bash

APP=komodo
NS=komodo
RELEASE_NAME=komodo

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

DB_USERNAME=$(yq '.cnpg.main.user' app-values.yaml)
DB_PASSWORD=$(yq '.cnpg.main.password' app-values-private.yaml)
if [[ "${DB_PASSWORD}" == "null" ]]; then
    DB_PASSWORD=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
    yq -i ".cnpg.main.password=\"${DB_PASSWORD}\"" app-values-private.yaml
fi

DB_DBNAME=$(yq '.cnpg.main.database' app-values.yaml)
MONGODB_URI="mongodb://${DB_USERNAME}:${DB_PASSWORD}@komodo-ferretdb:27017/${DB_DBNAME}"
yq -i ".workload.main.podSpec.containers.main.env.KOMODO_DATABASE_URI=\"${MONGODB_URI}\"" app-values-private.yaml
yq -i ".workload.main.podSpec.containers.main.env.KOMODO_DATABASE_USERNAME=\"${DB_USERNAME}\"" app-values-private.yaml
yq -i ".workload.main.podSpec.containers.main.env.KOMODO_DATABASE_PASSWORD=\"${DB_PASSWORD}\"" app-values-private.yaml

KOMODO_PASSKEY=$(yq '.workload.main.podSpec.containers.main.env.KOMODO_PASSKEY' app-values-private.yaml)
if [[ "${KOMODO_PASSKEY}" == "null" ]]; then
  KOMODO_PASSKEY=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".workload.main.podSpec.containers.main.env.KOMODO_PASSKEY=\"${KOMODO_PASSKEY}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    --post-renderer ./cnpg-pg-hba-post-renderer.sh \
    ${EXTRA_PARAMS}
