#!/bin/bash

APP=shiori
NS=shiori
RELEASE_NAME=shiori

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

SHIORI_HTTP_SECRET_KEY=$(yq '.workload.main.podSpec.containers.main.env.SHIORI_HTTP_SECRET_KEY' app-values-private.yaml)
if [[ "${SHIORI_HTTP_SECRET_KEY}" == "null" ]]; then
    SHIORI_HTTP_SECRET_KEY=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
    yq -i ".workload.main.podSpec.containers.main.env.SHIORI_HTTP_SECRET_KEY=\"${SHIORI_HTTP_SECRET_KEY}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
