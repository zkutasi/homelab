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

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --chart-name ${PWD}/chart \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --type local \
    --post-renderer ./cnpg-pg-hba-post-renderer.sh \
    ${EXTRA_PARAMS}
