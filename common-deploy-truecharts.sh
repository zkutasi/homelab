#!/bin/bash

APP=
CHART_NAME=
LATEST=0
NS=
RELEASE_NAME=
VERSION=

function usage() {
    echo "Usage: $0 --app <app-name> [--chart-name <chart-name>] [--latest] [--namespace <namespace>] [--release-name <release-name>] [--version <version>]"
    echo ""
    echo "Options:"
    echo "  --app <app-name>            Name of the application (required)"
    echo "  --chart-name <chart-name>   Full chart name, e.g., oci://tccr.io/truecharts/<app-name> (default: derived from app name)"
    echo "  --latest                    Use the latest chart version (overrides --version)"
    echo "  --namespace <namespace>     Kubernetes namespace to deploy to (default: same as app name)"
    echo "  --release-name <name>       Helm release name (default: same as app name)"
    echo "  --version <version>         Specific chart version to deploy (default: current or latest if not installed)"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --app)
      shift
      APP=$1
      ;;
    --chart-name)
      shift
      CHART_NAME=$1
      ;;
    --latest)
      LATEST=1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
    --version)
      shift
      VERSION=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${APP}" ] && echo "APP must be set" && exit 1
[ -z "${CHART_NAME}" ] && CHART_NAME=oci://tccr.io/truecharts/${APP}
[ -z "${NS}" ] && NS=${APP}
[ -z "${RELEASE_NAME}" ] && RELEASE_NAME=${APP}

if [ -z "${VERSION}" ] && [ $LATEST -eq 0 ]; then
  echo "Trying to figure out the current version..."
  current=$(helm -n $NS get metadata ${RELEASE_NAME} | grep ^VERSION | awk '{print $NF}')
  if [ -n "${current}" ]; then
    echo "Current version is ${current}"
    VERSION=${current}
  else
    echo "No current version found."
  fi
fi
if [ -z "${VERSION}" ]; then
  echo "Trying to figure out the latest version..."
  CURL_CHART_REPO=${CHART_NAME/oci/https}
  CURL_CHART_REPO=${CURL_CHART_REPO/tccr.io/tccr.io\/v2}
  latest=$(curl -s ${CURL_CHART_REPO}/tags/list | jq -r '.tags[]' | sort -V | tail -n1)
  echo "Latest version is ${latest}"
  VERSION=${latest}
fi

if [ ! -f "${APP}-values.yaml" ]; then
  echo "WARNING: No values file ${APP}-values.yaml found"
  echo "Creating an empty values file ${APP}-values.yaml"
  touch ${APP}-values.yaml
fi
if [ ! -f "${APP}-values-private.yaml" ]; then
  echo "WARNING: No private values file ${APP}-values-private.yaml found"
  echo "Creating an empty private values file ${APP}-values-private.yaml"
  touch ${APP}-values-private.yaml
fi

echo "Install helm chart..."
CMD="helm upgrade --install ${RELEASE_NAME} ${CHART_NAME} \
    --version ${VERSION} \
    --namespace $NS \
    --create-namespace \
    --values ${APP}-values.yaml \
    --values ${APP}-values-private.yaml \
    --debug"

echo "Executing command: ${CMD}"
${CMD}

echo "Apply additional manifests, if any..."
if [ -d "./extra-manifests" ]; then
  while read -r line; do
    kubectl apply -f "$line" -n $NS
  done < <(find ./extra-manifests -type f -name "*.yaml")
fi
