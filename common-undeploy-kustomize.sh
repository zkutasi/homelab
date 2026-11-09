#!/bin/bash

NS=

function usage() {
    echo "Usage: $0 --namespace <namespace>"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Kubernetes namespace the kustomization was deployed to, deleted at the end (required)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
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

echo "Delete the kustomization resources..."
kubectl delete --kustomize . --namespace "$NS" --ignore-not-found

echo "Delete additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl delete -f "$line" -n "$NS" --ignore-not-found
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi

echo "Deleting namespace ${NS}..."
kubectl delete namespace "$NS" --ignore-not-found
