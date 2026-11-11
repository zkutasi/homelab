#!/bin/bash

CNPG_REPO_URL=https://cloudnative-pg.github.io/charts
# renovate: datasource=helm depName=cluster registryUrl=https://cloudnative-pg.github.io/charts
CNPG_CLUSTER_CHART_VERSION=0.8.1

APP=app
CHART_NAME=
DEBUG=0
DEPLOYMENT_TYPE=helm
EXTRA_MANIFESTS=1
EXTRA_VALUES_FILES=()
LATEST=0
NS=
POST_RENDERER=
RELEASE_NAME=
REPO_NAME=
REPO_URL=
TEMPLATE=0
VERSION=

function usage() {
    cat <<EOF
Usage: $0 --chart-name <chart-name> --namespace <namespace> --release-name <release-name> [--app <app-name>] [--type <helm|truecharts|local>] [--repo-url <repo-url>] [--extra-values <file>] [--latest] [--no-extra-manifests] [--post-renderer <post-renderer>] [--template] [--debug] [--version <version>]

Options:
  --app <app-name>            Name of the application (default: app)
  --chart-name <chart-name>   Name of the Helm chart (e.g., stable/mychart or oci://oci.trueforge.org/truecharts/<app-name>) (required)
  --debug                     Pass --debug to helm for verbose output
  --extra-values <file>       Additional values file to pass to helm (can be specified multiple times, must exist)
  --latest                    Use the latest chart version instead of the deployed one (ignored when --version is given)
  --namespace <namespace>     Kubernetes namespace to deploy to (required)
  --no-extra-manifests        Do not apply the ./extra-manifests folder (e.g. when deploying a helper chart for an App)
  --post-renderer <post-renderer> Helm post-renderer script to modify manifests before deployment
  --release-name <release-name> Helm release name (required)
  --repo-url <repo-url>       URL of the Helm chart repository (required for helm deployment type)
  --template                  Template out the results for testing, do not deploy
  --type <type>               Type of deployment. Can be either of the following:
                                - helm         : for public Helm charts (default)
                                - truecharts   : for existing Truecharts helm chart
                                - local        : for local Truecharts helm chart
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
    --debug)
      DEBUG=1
      ;;
    --extra-values)
      shift
      EXTRA_VALUES_FILES+=("$1")
      ;;
    --latest)
      LATEST=1
      ;;
    --namespace)
      shift
      NS=$1
      ;;
    --no-extra-manifests)
      EXTRA_MANIFESTS=0
      ;;
    --post-renderer)
      shift
      POST_RENDERER=$1
      ;;
    --release-name)
      shift
      RELEASE_NAME=$1
      ;;
    --repo-url)
      shift
      REPO_URL=$1
      ;;
    --template)
      TEMPLATE=1
      ;;
    --type)
      shift
      DEPLOYMENT_TYPE=$1
      ;;
    --version)
      shift
      VERSION=$1
      ;;
    --help)
      usage
      exit 0
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
VALUE_FILES=()
for valuefile in "${APP}-values.yaml" "${APP}-values-private.yaml" "${APP}-values-dimensioning.yaml"; do
  if [ -f "${valuefile}" ]; then
    VALUE_FILES+=(--values "${valuefile}")
  else
    echo "INFO: No values file ${valuefile} found, skipping"
  fi
done
for valuefile in "${EXTRA_VALUES_FILES[@]}"; do
  [ ! -f "${valuefile}" ] && echo "ERROR: Extra values file ${valuefile} not found" && exit 1
  VALUE_FILES+=(--values "${valuefile}")
done

[ -z "${DEPLOYMENT_TYPE}" ] && echo "ERROR: Deployment type must be set" && exit 1
if [ "${DEPLOYMENT_TYPE}" == "truecharts" ]; then
  [ -z "${CHART_NAME}" ] && echo "ERROR: Chart name must be specified for truecharts deployment" && exit 1
  [ -z "${NS}" ] && echo "ERROR: Namespace must be specified for truecharts deployment" && exit 1
  [ -z "${RELEASE_NAME}" ] && echo "ERROR: Release name must be specified for truecharts deployment" && exit 1
elif [ "${DEPLOYMENT_TYPE}" == "helm" ]; then
  [ -z "${CHART_NAME}" ] && echo "ERROR: Chart name must be specified for helm deployment" && exit 1
  if [[ "${CHART_NAME}" != "oci://"* ]]; then
    [ -z "${REPO_URL}" ] && echo "ERROR: Repo URL must be specified for helm deployment if not OCI chart is used" && exit 1
  fi
  [ -z "${NS}" ] && echo "ERROR: Namespace must be specified for helm deployment" && exit 1
  [ -z "${RELEASE_NAME}" ] && echo "ERROR: Release name must be specified for helm deployment" && exit 1
  REPO_NAME=$(echo "${CHART_NAME}" | cut -d'/' -f1)
elif [ "${DEPLOYMENT_TYPE}" == "local" ]; then
  [ -z "${CHART_NAME}" ] && echo "ERROR: Chart name must be specified for helm deployment" && exit 1
  [ -z "${NS}" ] && echo "ERROR: Namespace must be specified for helm deployment" && exit 1
  [ -z "${RELEASE_NAME}" ] && echo "ERROR: Release name must be specified for helm deployment" && exit 1
  LATEST=1
else
  echo "ERROR: Invalid deployment type. Must be 'helm' or 'truecharts' or 'local'" && exit 1
fi

if [ "${DEPLOYMENT_TYPE}" == "helm" ] && [[ "${CHART_NAME}" != "oci://"* ]]; then
  echo "Add the helm repo if not already added..."
  if helm repo list | grep -q "^${REPO_NAME}[[:space:]]"; then
    echo "Helm repo ${REPO_NAME} already added."
  else
    helm repo add "${REPO_NAME}" "${REPO_URL}"
  fi
  echo "Update the added helm repo..."
  helm repo update "${REPO_NAME}"
fi

if [ -z "${VERSION}" ] && [ ${LATEST} -eq 0 ]; then
  echo "Trying to figure out the current version..."
  current=$(helm -n "$NS" get metadata "${RELEASE_NAME}" | grep ^VERSION | awk '{print $NF}')
  if [ -n "${current}" ]; then
    echo "Current version is ${current}"
    VERSION=${current}
  else
    echo "No current version found."
  fi
fi

if [ -z "${VERSION}" ]; then
  echo "Trying to figure out the latest version..."
  if [ "${DEPLOYMENT_TYPE}" == "truecharts" ] || [ "${DEPLOYMENT_TYPE}" == "helm" ]; then
    latest=$(helm show chart "${CHART_NAME}" | yq '.version // ""')
  elif [ "${DEPLOYMENT_TYPE}" == "local" ]; then
    latest=local
  fi
  echo "Latest version is ${latest}"
  VERSION=${latest}
fi

[ -z "${VERSION}" ] && echo "ERROR: No version specified" && exit 1

if [ "${DEPLOYMENT_TYPE}" == "local" ]; then
  echo "Running helm dependency update for local helm chart..."
  helm dependency update "${CHART_NAME}"
fi

CMD=("${RELEASE_NAME}" "${CHART_NAME}"
    --version "${VERSION}"
    --namespace $NS
    --create-namespace
    "${VALUE_FILES[@]}")

if [ "${DEBUG}" -eq 1 ]; then
  CMD+=(--debug)
fi

if [ -n "${POST_RENDERER}" ]; then
  CMD+=(--post-renderer "${POST_RENDERER}")
fi

if [ "${TEMPLATE}" -eq 0 ]; then
  echo "Install helm chart..."
  CMD=(helm upgrade --install "${CMD[@]}")
else
  echo "Template out the result..."
  CMD=(helm template "${CMD[@]}")
fi
echo "Executing command: ${CMD[*]}"
"${CMD[@]}"

if [ "${TEMPLATE}" -eq 0 ] && { [ "${DEPLOYMENT_TYPE}" == "truecharts" ] || [ "${DEPLOYMENT_TYPE}" == "local" ]; }; then
  cnpg_clusters=$(helm -n "${NS}" get values -a "${RELEASE_NAME}" \
    | yq '.cnpg // {} | to_entries | .[] | select(.value.enabled == true) | .key')
  for cnpg_clustername in ${cnpg_clusters}; do
    echo "Deploying Prometheus rules for CNPG cluster ${cnpg_clustername}..."
    CMD=(helm template
      --release-name "${RELEASE_NAME}-cnpg"
      --namespace $NS
      --set "nameOverride=${cnpg_clustername}"
      --set cluster.monitoring.enabled=true
      --set "cluster.monitoring.prometheusRule.excludeRules[0]=CNPGClusterHAWarning"
      --set "cluster.monitoring.prometheusRule.excludeRules[1]=CNPGClusterHACritical"
      --show-only templates/prometheus-rule.yaml
      --repo "${CNPG_REPO_URL}"
      --version "${CNPG_CLUSTER_CHART_VERSION}"
      cluster)
    echo "Executing command: ${CMD[*]}"
    "${CMD[@]}" | kubectl apply -f -
  done
fi

if [ "${TEMPLATE}" -eq 0 ] && [ "${EXTRA_MANIFESTS}" -eq 1 ]; then
  echo "Apply additional manifests, if any..."
  if [ -d "./extra-manifests" ]; then
    while read -r line; do
      kubectl apply -f "$line" -n "$NS"
    done < <(find ./extra-manifests -type f -name "*.yaml" | sort)
  fi
fi
