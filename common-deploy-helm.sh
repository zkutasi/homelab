#!/bin/bash

APP=app
CHART_NAME=
LATEST=0
NS=
RELEASE_NAME=
REPO_NAME=
REPO_URL=
VERSION=

function usage() {
    echo "Usage: $0 --app <app> --chart-name <chart-name> --repo-url <repo-url> --namespace <namespace> --release-name <release-name> [--version <version>] [--latest]"
    echo ""
    echo "Options:"
    echo "  --app <app>                 Name of the application (used for values files)"
    echo "  --chart-name <chart-name>   Name of the Helm chart (e.g., stable/mychart)"
    echo "  --repo-url <repo-url>       URL of the Helm chart repository"
    echo "  --namespace <namespace>     Kubernetes namespace to deploy to"
    echo "  --release-name <release-name> Name of the Helm release"
    echo "  --version <version>         Version of the Helm chart to deploy (if not specified, tries to use current version or latest)"
    echo "  --latest                    Use the latest version of the Helm chart"
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
      REPO_NAME=$(echo ${CHART_NAME} | cut -d'/' -f1)
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
    --repo-url)
      shift
      REPO_URL=$1
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

[ -z "${REPO_NAME}" ] && echo "ERROR: No repo name specified" && exit 1
[ -z "${REPO_URL}" ] && echo "ERROR: No repo URL specified" && exit 1

echo "Add the helm repo if not already added..."
if helm repo list | grep -q "^${REPO_NAME}[[:space:]]"; then
  echo "Helm repo ${REPO_NAME} already added."
else
  helm repo add ${REPO_NAME} ${REPO_URL}
  echo "Update helm repos..."
  helm repo update
fi

[ -z "${NS}" ] && echo "ERROR: No namespace specified" && exit 1
[ -z "${RELEASE_NAME}" ] && echo "ERROR: No release name specified" && exit 1

if [ -z "${VERSION}" ] && [ ${LATEST} -eq 0 ]; then
  echo "Trying to figure out the current version..."
  current=$(helm -n $NS get metadata ${RELEASE_NAME} | grep ^VERSION | awk '{print $NF}')
  if [ -n "${current}" ]; then
    echo "Current version is ${current}"
    VERSION=${current}
  else
    echo "No current version found."
  fi
fi

[ -z "${CHART_NAME}" ] && echo "ERROR: No chart name specified" && exit 1

echo "Trying to figure out the latest version..."
latest=$(helm search repo --regexp "\v${CHART_NAME}\v" | tail -n1 | awk '{print $2}')
echo "Latest version is ${latest}"
if [ -z "${VERSION}" ]; then
  VERSION=${latest}
fi

[ -z "${VERSION}" ] && echo "ERROR: No version specified" && exit 1

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
