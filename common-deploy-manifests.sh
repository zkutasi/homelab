#!/bin/bash

NS=

function usage() {
    echo "Usage: $0 [--namespace <namespace>]"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Kubernetes namespace to deploy to, created if missing (omit for cluster-wide manifests)"
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

NS_ARGS=
if [ -n "${NS}" ]; then
  echo "Ensure namespace $NS exists..."
  kubectl get namespace "$NS" >/dev/null 2>&1 || kubectl create namespace "$NS"
  NS_ARGS="--namespace ${NS}"
fi

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" ${NS_ARGS}
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
