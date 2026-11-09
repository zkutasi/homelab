#!/bin/bash

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

# Cluster-wide manifests, so no namespace is given
"$(git rev-parse --show-toplevel)"/common-deploy-manifests.sh \
    ${EXTRA_PARAMS}
