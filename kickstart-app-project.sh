#!/bin/bash

APP_NAME=
APP_NAME_LOWERCASE=
APP_FOLDERNAME=
ANSIBLE_HOST=
TYPE=docker
MAINTYPE=docker
SUBTYPE=

function usage() {
    cat <<EOF
Usage: $0 --foldername <foldername> --appname <appname> [--host <ansible_host>] [--type <docker|k8s>]

Options:
  --foldername <foldername>   Specify the folder to create (required)
  --appname <appname>         Specify the application name to use as a replacement (required)
  --host <ansible_host>       Specify the Ansible host for deployment
  --type <type>               Specify the template type. Default: docker
                              can be either of the following:
                              - docker               : for Docker Compose based deployments
                              - k8s.helm             : for Kubernetes based deployments with Helm charts
                              - k8s.kompose          : for Kubernetes based deployments with Kompose files
                              - k8s.kustomize        : for Kubernetes based deployments with Kustomize files
                              - k8s.truecharts       : for Kubernetes based deployments with existing Truecharts helm chart
                              - k8s.truecharts-local : for Kubernetes based deployments with non-existing Truecharts helm chart
EOF
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
      MAINTYPE=$(echo ${TYPE} | awk -F. '{print $1}')
      SUBTYPE=$(echo ${TYPE} | awk -F. '{print $2}')
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

if [[ "${MAINTYPE}" != "docker" && "${MAINTYPE}" != "k8s" ]]; then
    echo "ERROR: Invalid type specified. Allowed values are 'docker' or 'k8s'."
    usage
    exit 1
fi

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
fi

TARGET_APP_DIR="${REPO_ROOT}/${APP_FOLDERNAME}"

echo "Preparing to kickstart app '${APP_NAME}' in folder '${APP_FOLDERNAME}' using '${TYPE}' templates."
echo "Copy files..."
mkdir -p "${TARGET_APP_DIR}"
cp -r ${REPO_ROOT}/_templates/${MAINTYPE}/* "${TARGET_APP_DIR}"

if [ "${MAINTYPE}" == "docker" ]; then
    if [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
        echo "Processing existing docker-compose.yaml for templating..."
        cp ${TARGET_APP_DIR}/docker-compose.yaml ${TARGET_APP_DIR}/docker-compose.yaml.j2

        yq -i ".services.${APP_NAME_LOWERCASE}.image |= sub(\":.*$\", \":{{ requested_image_version['${APP_NAME_LOWERCASE}'] }}\")" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.restart = \"unless-stopped\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i 'sort_keys(..)' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        add_yaml_key_as_map "${TARGET_APP_DIR}/docker-compose.yaml.j2" ".services.${APP_NAME_LOWERCASE}.environment" "TZ" "{{ timezone }}"
    fi
elif [ "${MAINTYPE}" == "k8s" ]; then
    if [ -n "${SUBTYPE}" ] && [ -d "${REPO_ROOT}/_templates/${TYPE}" ]; then
        cp -r ${REPO_ROOT}/_templates/${TYPE}/* "${TARGET_APP_DIR}"
    fi
    if [ "${SUBTYPE}" == "truecharts-local" ]; then
        if [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
            echo "Gathering information from docker-compose.yaml for Truecharts values.yaml..."
            SERVICES=$(yq ".services | keys | .[]" "${TARGET_APP_DIR}/docker-compose.yaml")
            IMAGES=$(yq ".services[].image" "${TARGET_APP_DIR}/docker-compose.yaml")
            POSTGRESQL=$(yq '.services[].image | select(test("postgres"))' "${TARGET_APP_DIR}/docker-compose.yaml")
            echo "Converting docker-compose.yaml for Truecharts values.yaml..."
            echo > "${TARGET_APP_DIR}/app-values.yaml"
            if [ -n "${POSTGRESQL}" ]; then
              yq -i ".cnpg.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.cluster.instances = 1" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.cluster.singleNode = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.cluster.storage.size = \"2Gi\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.cluster.walStorage.size = \"2Gi\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.database = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.monitoring.enablePodMonitor = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.user = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
            fi
            APP_SERVICES=($(yq '.services | with_entries( select(.value.image | test("postgres|redis") | not) ) | keys[]' "${TARGET_APP_DIR}/docker-compose.yaml"))
            if (( ${#APP_SERVICES[@]} == 1 )); then
              APP_IMAGE=$(yq ".services.${APP_SERVICES[0]}.image" "${TARGET_APP_DIR}/docker-compose.yaml")
              yq -i ".image.repository = \"${APP_IMAGE%%:*}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".image.tag = \"${APP_IMAGE##*:}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".image.pullPolicy = \"IfNotPresent\"" "${TARGET_APP_DIR}/app-values.yaml"

              APP_PORT=$(yq ".services.${APP_SERVICES[0]}.ports[0]" "${TARGET_APP_DIR}/docker-compose.yaml" | cut -d':' -f1)
              yq -i ".service.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.port = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.protocol = \"http\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.targetPort = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".TZ = \"Europe/Budapest\"" "${TARGET_APP_DIR}/app-values.yaml"

              yq -i ".workload.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.type = \"Deployment\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.podSpec.containers.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.podSpec.containers.main.probes.liveness.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.podSpec.containers.main.probes.readiness.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.podSpec.containers.main.probes.startup.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"
            else
              echo "UNIMPLEMENTED: More than one application service found. Skipping image configuration."
            fi
        fi
    fi
fi

echo "Swap out templates..."
while read -r line; do
  sed -i "s|<APP_NAME_LOWERCASE>|${APP_NAME_LOWERCASE}|g" ${line}
  sed -i "s|<APP_NAME>|${APP_NAME}|g" ${line}
  sed -i "s|<APP_FOLDERNAME>|${APP_FOLDERNAME}|g" ${line}
  if [ -n "${ANSIBLE_HOST}" ]; then
    sed -i "s|<ANSIBLE_HOST>|${ANSIBLE_HOST}|g" ${line}
  fi
  if [ -n "${APP_PORT}" ]; then
    sed -i "s|<APP_PORT>|${APP_PORT}|g" ${line}
  fi
done < <(find ${TARGET_APP_DIR} -type f)

echo "Renaming..."
if [ "${TYPE}" == "docker" ]; then
    mv "${TARGET_APP_DIR}/deploy.yaml" "${TARGET_APP_DIR}/deploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${TARGET_APP_DIR}/undeploy.yaml" "${TARGET_APP_DIR}/undeploy-${APP_NAME_LOWERCASE}.yaml"
fi

echo "Kickstart completed successfully for app '${APP_NAME}' in folder '${APP_FOLDERNAME}'."
