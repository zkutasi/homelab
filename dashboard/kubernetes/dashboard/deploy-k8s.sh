#!/bin/bash

CHART_NAME=kubernetes-dashboard/kubernetes-dashboard
NS=kubernetes-dashboard
RELEASE_NAME=kubernetes-dashboard
REPO_URL=https://kubernetes.github.io/dashboard/
VERSION=7.12.0

EXTRA_PARAMS=

while [ $# -ge 1 ]; do
  case "$1" in
    *)
      EXTRA_PARAMS="${EXTRA_PARAMS} $1"
      ;;
  esac
  shift
done

"$(git rev-parse --show-toplevel)"/common-deploy-helm.sh \
    --chart-name "${CHART_NAME}" \
    --namespace $NS \
    --release-name "${RELEASE_NAME}" \
    --repo-url "${REPO_URL}" \
    --version "${VERSION}" \
    ${EXTRA_PARAMS}

kubectl create token kube-ds-viewer -n $NS
kubectl create token kube-ds-editor -n $NS
kubectl create token kube-ds-admin -n $NS
