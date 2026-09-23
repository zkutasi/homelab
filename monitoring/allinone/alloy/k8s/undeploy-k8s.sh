#!/bin/bash

NS=monitoring
RELEASE_NAME=alloy

EXTRA_PARAMS="--delete-namespace 0"

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-undeploy-helm.sh \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}
