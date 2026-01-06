#!/bin/bash

APP=arcane
NS=arcane
RELEASE_NAME=arcane

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

ENCRYPTION_KEY=$(yq '.workload.main.podSpec.containers.main.env.ENCRYPTION_KEY' app-values-private.yaml)
if [[ "${ENCRYPTION_KEY}" == "null" ]]; then
  ENCRYPTION_KEY=$(dd if=/dev/urandom bs=1 count=32 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 32)
  yq -i ".workload.main.podSpec.containers.main.env.ENCRYPTION_KEY=\"${ENCRYPTION_KEY}\"" app-values-private.yaml
fi

JWT_SECRET=$(yq '.workload.main.podSpec.containers.main.env.JWT_SECRET' app-values-private.yaml)
if [[ "${JWT_SECRET}" == "null" ]]; then
  JWT_SECRET=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".workload.main.podSpec.containers.main.env.JWT_SECRET=\"${JWT_SECRET}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
