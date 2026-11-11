#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

APP=kuvasz
CHART_NAME=oci://ghcr.io/kuvasz-uptime/kuvasz-uptime
NS=kuvasz
RELEASE_NAME=kuvasz
VERSION=3.5.1

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

"$(git rev-parse --show-toplevel)"/common-deploy-cnpg.sh \
    --app ${APP}-postgresql \
    --db-database ${APP} \
    --db-username ${APP} \
    --namespace $NS \
    ${EXTRA_PARAMS}

kubectl create secret generic ca-certificates \
    --namespace $NS \
    --from-file=cacerts=config/static/cacerts \
    --dry-run=client -o yaml | kubectl apply -f -

"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}
