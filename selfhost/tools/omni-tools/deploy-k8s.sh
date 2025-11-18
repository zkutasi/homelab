#!/bin/bash

APP=omni-tools
NS=omni-tools
RELEASE_NAME=omni-tools

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
    ${EXTRA_PARAMS}
