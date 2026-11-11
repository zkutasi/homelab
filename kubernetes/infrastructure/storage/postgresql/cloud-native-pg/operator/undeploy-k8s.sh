#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

NS=cnpg-system
RELEASE_NAME=cnpg

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

CLUSTERS=
if kubectl get crd clusters.postgresql.cnpg.io >/dev/null 2>&1; then
  if ! CLUSTERS=$(kubectl get clusters.postgresql.cnpg.io \
      --all-namespaces \
      -o go-template \
      --template='{{range .items}}{{.metadata.namespace}}/{{.metadata.name}}{{"\n"}}{{end}}'); then
    echo "ERROR: Could not list the PostgreSQL clusters, not uninstalling the operator"
    exit 1
  fi
fi

if [ -n "${CLUSTERS}" ]; then
  echo "The following PostgreSQL clusters exist and must be deleted before uninstalling the operator:"
  echo "${CLUSTERS}"
  exit 1
fi

"$(git rev-parse --show-toplevel)"/common-undeploy-helm.sh \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}
