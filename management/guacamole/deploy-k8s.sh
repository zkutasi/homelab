#!/bin/bash

APP=guacamole

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

$(git rev-parse --show-toplevel)/common-deploy-truecharts.sh \
    --app "${APP}" \
    ${EXTRA_PARAMS}
