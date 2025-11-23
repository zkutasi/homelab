#!/bin/bash

NS=redis-operator
RELEASE_NAME=redis-operator

EXTRA_PARAMS=""

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

REDISES=$(kubectl get redis.redis.redis.opstreelabs.in \
    --all-namespaces \
    -o go-template \
    --template='{{range .items}}{{.metadata.namespace}}/{{.metadata.name}}{{"\n"}}{{end}}')

if [ -n "${REDISES}" ]; then
  echo "The following Redises exist and must be deleted before uninstalling the operator:"
  echo "${REDISES}"
  exit 1
fi

$(git rev-parse --show-toplevel)/common-undeploy-helm.sh \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    ${EXTRA_PARAMS}
