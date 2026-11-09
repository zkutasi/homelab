#!/bin/bash

# Remove the rendered manifests also when the build fails, the exit code of kustomize is kept
trap 'rm -f all.yaml' EXIT

cat <&0 > all.yaml

kustomize build .
