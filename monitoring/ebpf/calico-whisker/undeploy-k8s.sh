#!/bin/bash

NS=kube-system

echo "Delete the manifests..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl delete -f "$line" -n $NS --ignore-not-found
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi

echo "Delete the generated TLS secrets..."
kubectl -n $NS delete secret goldmane-tls whisker-backend-tls whisker-cert-secret --ignore-not-found
