#!/bin/bash

APP=dockpeek
NS=dockpeek
RELEASE_NAME=dockpeek

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

SECRET_KEY=$(yq '.workload.main.podSpec.containers.main.env.SECRET_KEY' app-values-private.yaml)
if [[ "${SECRET_KEY}" == "null" ]]; then
  SECRET_KEY=$(dd if=/dev/urandom bs=1 count=12 status=none | base64 | tr -dc 'a-zA-Z0-9' | head -c 12)
  yq -i ".workload.main.podSpec.containers.main.env.SECRET_KEY=\"${SECRET_KEY}\"" app-values-private.yaml
fi

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    ${EXTRA_PARAMS}
