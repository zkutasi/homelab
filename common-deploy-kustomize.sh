#!/bin/bash

NS=

function usage() {
    echo "Usage: $0 --namespace <namespace>"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Specify the Kubernetes namespace to deploy to (required)"
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

echo "Ensure namespace $NS exists..."
kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

echo "Apply kustomization.yaml..."
CMD="kubectl apply \
    --kustomize . \
	  --namespace $NS"

echo "Executing command: ${CMD}"
${CMD}

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
