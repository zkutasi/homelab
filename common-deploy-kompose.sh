#!/bin/bash

NS=

function usage() {
    echo "Usage: $0 --namespace <namespace>"
    echo ""
    echo "Options:"
    echo "  --namespace <namespace>   Specify the Kubernetes namespace to deploy to (required)"
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

while [ $# -ge 1 ]; do
  case "$1" in
    --namespace)
      require_value "$1" "$2"
      shift
      NS=$1
      ;;
    --help)
      usage
      exit 0
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

echo "Execute Kompose conversion..."
rm -rf ./kompose-manifests/*
mkdir -p ./kompose-manifests
CMD=(kompose convert
    --file docker-compose.yaml
    --service-group-mode label
    --out ./kompose-manifests)

echo "Executing command: ${CMD[*]}"
if ! "${CMD[@]}"; then
  echo "ERROR: kompose convert failed, not applying anything"
  exit 1
fi

echo "Ensure namespace $NS exists..."
kubectl get namespace "$NS" >/dev/null 2>&1 || kubectl create namespace "$NS"

echo "Apply Kompose manifests..."
if [ -d "./kompose-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n "$NS"
  done < <(find ./kompose-manifests -type f -name "*.yaml" | sort)
fi

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n "$NS"
  done < <(find ./extra-manifests -type f -name "*.yaml" | sort)
fi
