#!/bin/bash

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line"
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
