#!/bin/bash

pushd librenms &>/dev/null

cat <&0 > all.yaml

kustomize build . && rm all.yaml

popd &>/dev/null
