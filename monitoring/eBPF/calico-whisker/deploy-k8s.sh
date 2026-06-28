#!/bin/bash

CA_DIR=$(git rev-parse --show-toplevel)/security/certificates/certs/
NS=kube-system

kubectl create secret tls goldmane
    --namespace $NS \
    --cert
    --key

kubectl create secret generic goldmane-internal-ca-secret \
    --namespace $NS \
    --from-file=tls.key=${CA_DIR}/ca.key \
    --from-file=tls.crt=${CA_DIR}/ca.crt

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
