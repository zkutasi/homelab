#!/bin/bash

NS=wazuh
VERSION="4.14.2"

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

if [ ! -d wazuh-kubernetes ]; then
  echo "Cloning wazuh-kubernetes repo..."
  git clone https://github.com/wazuh/wazuh-kubernetes.git -b v${VERSION} --depth=1
else
  echo "Updating wazuh-kubernetes repo to ${VERSION}..."
  pushd wazuh-kubernetes
  git fetch origin
  git pull --tags
  git checkout v${VERSION}
  popd
fi
if [ ! -f wazuh-kubernetes/wazuh/certs/indexer_cluster/filebeat.pem ]; then
  ./wazuh-kubernetes/wazuh/certs/indexer_cluster/generate_certs.sh
fi
if [ ! -f wazuh-kubernetes/wazuh/certs/dashboard_http/cert.pem ]; then
  ./wazuh-kubernetes/wazuh/certs/dashboard_http/generate_certs.sh
fi

$(git rev-parse --show-toplevel)/common-deploy-kustomize.sh \
    --namespace $NS \
    ${EXTRA_PARAMS}
