#!/bin/bash

APP_NAME=
APP_FOLDERNAME=
TYPE=docker

function usage() {
    echo "Usage: $0 --foldername <foldername> --appname <appname> [--type <docker|k8s>]"
    echo ""
    echo "Options:"
    echo "  --foldername <foldername>   Specify the folder to create (required)"
    echo "  --appname <appname>         Specify the application name to use as a replacement (required)"
    echo "  --type <type>               Specify the template type (docker or k8s). Default: docker"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --foldername)
      shift
      APP_FOLDERNAME=$1
      ;;
    --appname)
      shift
      APP_NAME=$1
      ;;
    --type)
      shift
      TYPE=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${APP_FOLDERNAME}" ] && echo "ERROR: No foldername specified" && usage && exit 1
[ -z "${APP_NAME}" ] && echo "ERROR: No appname specified" && usage && exit 1
if [[ "${TYPE}" != "docker" && "${TYPE}" != "k8s" ]]; then
    echo "ERROR: Invalid type specified. Allowed values are 'docker' or 'k8s'."
    usage
    exit 1
fi

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
fi

TEMPLATE_SOURCE_DIR="${REPO_ROOT}/_templates/${TYPE}"
TARGET_APP_DIR="${REPO_ROOT}/${APP_FOLDERNAME}"

echo "Preparing to kickstart app '${APP_NAME}' in folder '${APP_FOLDERNAME}' using '${TYPE}' templates."
mkdir -p "${TARGET_APP_DIR}"
cp -r "${TEMPLATE_SOURCE_DIR}/." "${TARGET_APP_DIR}/"
cp "${REPO_ROOT}/_templates/README.layer2.md" "${TARGET_APP_DIR}/README.md"
find "${TARGET_APP_DIR}" -type f -exec sed -i "s/APP_NAME/${APP_NAME}/g" {} +
find "${TARGET_APP_DIR}" -type f -exec sed -i "s/APP_FOLDERNAME/${APP_FOLDERNAME}/g" {} +

if [ "${TYPE}" == "docker" ]; then
    mv "${TARGET_APP_DIR}/deploy.yaml" "${TARGET_APP_DIR}/deploy-${APP_NAME}.yaml"
    mv "${TARGET_APP_DIR}/undeploy.yaml" "${TARGET_APP_DIR}/undeploy-${APP_NAME}.yaml"
fi

echo "Kickstart completed successfully for app '${APP_NAME}' in folder '${APP_FOLDERNAME}'."
