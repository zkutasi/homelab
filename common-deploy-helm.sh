#!/bin/bash

APP=app
CHART_NAME=
DEPLOYMENT_TYPE=helm
LATEST=0
NS=
RELEASE_NAME=
REPO_NAME=
REPO_URL=
VERSION=

function usage() {
    cat <<EOF
Usage: $0 --app <app-name> --deployment-type <helm|truecharts> [--chart-name <chart-name>] [--repo-url <repo-url>] [--latest] [--namespace <namespace>] [--release-name <release-name>] [--version <version>]

Options:
  --app <app-name>            Name of the application (default: app)
  --type <type>               Type of deployment. Can be either of the following:
                                - helm         : for public Helm charts (default)
                                - truecharts   : for existing Truecharts helm chart
                                - local        : for local Truecharts helm chart
  --chart-name <chart-name>   Name of the Helm chart (e.g., stable/mychart or oci://tccr.io/truecharts/<app-name>)
  --repo-url <repo-url>       URL of the Helm chart repository (required for helm deployment type)
  --latest                    Use the latest chart version (overrides --version)
  --namespace <namespace>     Kubernetes namespace to deploy to (default: same as app name)
  --release-name <release-name> Helm release name (default: same as app name)
  --version <version>         Specific chart version to deploy (default: current or latest if not installed)
EOF
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
    --repo-url)
      shift
      REPO_URL=$1
      ;;
    --type)
      shift
      DEPLOYMENT_TYPE=$1
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

[ -z "${APP}" ] && echo "ERROR: APP must be set" && exit 1
[ -z "${DEPLOYMENT_TYPE}" ] && echo "ERROR: Deployment type must be set" && exit 1

if [ "${DEPLOYMENT_TYPE}" == "truecharts" ]; then
  [ -z "${CHART_NAME}" ] && CHART_NAME=oci://tccr.io/truecharts/${APP}
  [ -z "${NS}" ] && NS=${APP}
  [ -z "${RELEASE_NAME}" ] && RELEASE_NAME=${APP}
elif [ "${DEPLOYMENT_TYPE}" == "helm" ]; then
  [ -z "${CHART_NAME}" ] && echo "ERROR: Chart name must be specified for helm deployment" && exit 1
  [ -z "${REPO_URL}" ] && echo "ERROR: Repo URL must be specified for helm deployment" && exit 1
  [ -z "${NS}" ] && echo "ERROR: Namespace must be specified for helm deployment" && exit 1
  [ -z "${RELEASE_NAME}" ] && echo "ERROR: Release name must be specified for helm deployment" && exit 1
  REPO_NAME=$(echo ${CHART_NAME} | cut -d'/' -f1)
else
  echo "ERROR: Invalid deployment type. Must be 'helm' or 'truecharts'" && exit 1
fi

if [ "${DEPLOYMENT_TYPE}" == "helm" ]; then
  echo "Add the helm repo if not already added..."
  if helm repo list | grep -q "^${REPO_NAME}[[:space:]]"; then
    echo "Helm repo ${REPO_NAME} already added."
  else
    helm repo add ${REPO_NAME} ${REPO_URL}
    echo "Update helm repos..."
    helm repo update
  fi
fi

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

if [ -z "${VERSION}" ]; then
  echo "Trying to figure out the latest version..."
  if [ "${DEPLOYMENT_TYPE}" == "truecharts" ]; then
    CURL_CHART_REPO=${CHART_NAME/oci/https}
    CURL_CHART_REPO=${CURL_CHART_REPO/tccr.io/tccr.io\/v2}
    latest=$(curl -s ${CURL_CHART_REPO}/tags/list | jq -r '.tags[]' | sort -V | tail -n1)
  elif [ "${DEPLOYMENT_TYPE}" == "helm" ]; then
    latest=$(helm search repo --regexp "\v${CHART_NAME}\v" | tail -n1 | awk '{print $2}')
  fi
  echo "Latest version is ${latest}"
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
