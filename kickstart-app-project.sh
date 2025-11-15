#!/bin/bash

APP_NAME=
APP_NAME_LOWERCASE=
APP_FOLDERNAME=
ANSIBLE_HOST=
TYPE=docker

function usage() {
    echo "Usage: $0 --foldername <foldername> --appname <appname> [--host <ansible_host>] [--type <docker|k8s>]"
    echo ""
    echo "Options:"
    echo "  --foldername <foldername>   Specify the folder to create (required)"
    echo "  --appname <appname>         Specify the application name to use as a replacement (required)"
    echo "  --host <ansible_host>       Specify the Ansible host for deployment"
    echo "  --type <type>               Specify the template type (docker or k8s). Default: docker"
}

function add_yaml_key_as_map() {
    local file=$1
    local path=$2
    local key=$3
    local value=$4

    echo "Adding key '${key}' to path '${path}' in ${file}"

    # Check if the path exists
    if yq -e "${path}" "${file}" >/dev/null; then
        # Path exists, check if it's a list (sequence) or a map
        local env_type
        env_type=$(yq "${path} | type" "${file}")
        if [[ "${env_type}" == "!!seq" ]]; then
            # It's a list
            yq -i "${path} += [\"${key}=${value}\"]" "${file}"
        else
            # It's a map or something else, treat as map
            yq -i "${path}.${key} = \"${value}\"" "${file}"
        fi
    else
        # Path doesn't exist, create it as a map
        yq -i "${path}.${key} = \"${value}\"" "${file}"
    fi
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
      APP_NAME_LOWERCASE=$(echo ${APP_NAME} | tr '[:upper:]' '[:lower:]')
      ;;
    --host)
      shift
      ANSIBLE_HOST=$1
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
echo "Copy files..."
mkdir -p "${TARGET_APP_DIR}"
cp -r "${TEMPLATE_SOURCE_DIR}/." "${TARGET_APP_DIR}/"
cp "${REPO_ROOT}/_templates/README.layer2.md" "${TARGET_APP_DIR}/README.md"

if [ "${TYPE}" == "docker" ] && [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
    echo "Processing existing docker-compose.yaml for templating..."
    cp ${TARGET_APP_DIR}/docker-compose.yaml ${TARGET_APP_DIR}/docker-compose.yaml.j2

    yq -i ".services.${APP_NAME_LOWERCASE}.image |= sub(\":.*$\", \":{{ requested_image_version['${APP_NAME_LOWERCASE}'] }}\")" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.restart = \"unless-stopped\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
    yq -i 'sort_keys(..)' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
    add_yaml_key_as_map "${TARGET_APP_DIR}/docker-compose.yaml.j2" ".services.${APP_NAME_LOWERCASE}.environment" "TZ" "{{ timezone }}"
fi

echo "Swap out templates..."
sed -i "s|<APP_NAME_LOWERCASE>|${APP_NAME_LOWERCASE}|g" ${TARGET_APP_DIR}/*
sed -i "s|<APP_NAME>|${APP_NAME}|g" ${TARGET_APP_DIR}/*
sed -i "s|<APP_FOLDERNAME>|${APP_FOLDERNAME}|g" ${TARGET_APP_DIR}/*
if [ -n "${ANSIBLE_HOST}" ]; then
  sed -i "s|<ANSIBLE_HOST>|${ANSIBLE_HOST}|g" ${TARGET_APP_DIR}/*
fi

echo "Renaming..."
if [ "${TYPE}" == "docker" ]; then
    mv "${TARGET_APP_DIR}/deploy.yaml" "${TARGET_APP_DIR}/deploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${TARGET_APP_DIR}/undeploy.yaml" "${TARGET_APP_DIR}/undeploy-${APP_NAME_LOWERCASE}.yaml"
fi

echo "Kickstart completed successfully for app '${APP_NAME}' in folder '${APP_FOLDERNAME}'."
