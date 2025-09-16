#!/bin/bash

NS=

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

echo "Execute Kompose conversion..."
rm -rf ./kompose-manifests/*
CMD="kompose convert \
    --file docker-compose.yaml \
    --service-group-mode label \
    --out ./kompose-manifests"

echo "Executing command: ${CMD}"
${CMD}

echo "Ensure namespace $NS exists..."
kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

echo "Apply Kompose manifests..."
if [ -d "./kompose-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./kompose-manifests -type f -name "*.yaml")
fi

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
