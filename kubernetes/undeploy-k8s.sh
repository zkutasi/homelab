#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

NS=kube-system

echo "Delete the manifests, the kube-system namespace stays..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl delete -f "$line" -n $NS --ignore-not-found
  done < <(find ./extra-manifests -type f -name "*.yaml" | sort)
fi
