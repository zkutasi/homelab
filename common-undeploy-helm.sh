#!/bin/bash

DEBUG=0
DELETE_NAMESPACE=1
NS=
RELEASE_NAME=

function usage() {
    echo "Usage: $0 --namespace <namespace> --release-name <release-name> [--delete-namespace <0|1>] [--debug]"
    echo ""
    echo "Options:"
    echo "  --debug                         Pass --debug to helm for verbose output"
    echo "  --namespace <namespace>         Kubernetes namespace where the Helm release is deployed (required)"
    echo "  --release-name <release-name>   Name of the Helm release to uninstall (required)"
    echo "  --delete-namespace <0|1>        Whether to delete the namespace after uninstalling the Helm release (default: 1)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --debug)
      DEBUG=1
      ;;
    --delete-namespace)
      shift
      DELETE_NAMESPACE=$1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${NS}" ] && echo "ERROR: No namespace specified" && exit 1
[ -z "${RELEASE_NAME}" ] && echo "ERROR: No release name specified" && exit 1

echo "Uninstall helm chart..."
RELEASES=$(helm -n $NS list --short)
if echo "${RELEASES}" | grep -q "^${RELEASE_NAME}$"; then
  CMD="helm uninstall ${RELEASE_NAME} \
        --namespace $NS \
        --wait"
  if [ "${DEBUG}" -eq 1 ]; then
    CMD="${CMD} --debug"
  fi

  echo "Executing command: ${CMD}"
  ${CMD}
else
  echo "Helm release ${RELEASE_NAME} not found in namespace ${NS}, skipping uninstall"
fi

if [ ${DELETE_NAMESPACE} -eq 1 ]; then
  echo "Deleting namespace ${NS}..."
  kubectl delete namespace $NS
fi
