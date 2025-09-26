#!/bin/bash

NS=
RELEASE_NAME=

function usage() {
    echo "Usage: $0 --namespace <namespace>"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Specify the Kubernetes namespace to delete (required)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --namespace)
      shift
      NS=$1
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

echo "Deleting namespace ${NS}..."
kubectl delete namespace $NS
