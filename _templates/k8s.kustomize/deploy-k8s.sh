#!/bin/bash

NS=<APP_NAME_LOWERCASE>

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-kustomize.sh \
    --namespace $NS \
    ${EXTRA_PARAMS}
