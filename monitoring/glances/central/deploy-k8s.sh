#!/bin/bash

APP=glances
VERSION=3.1.0 # Later version require more recent Kubernetes cluster

EXTRA_PARAMS="--extra-values glances-values-config-private.yaml"

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-helm.sh \
    --app "${APP}" \
    --type truecharts \
    --version ${VERSION} \
    ${EXTRA_PARAMS}
