#!/bin/bash

APP=kener
NS=kener
RELEASE_NAME=kener

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

KENER_SECRET_KEY=$(yq '.workload.main.podSpec.containers.main.env.KENER_SECRET_KEY' app-values-private.yaml)
if [[ "${KENER_SECRET_KEY}" == "null" ]]; then
  KENER_SECRET_KEY=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".workload.main.podSpec.containers.main.env.KENER_SECRET_KEY=\"${KENER_SECRET_KEY}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
