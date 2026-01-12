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

        yq -i ".services.${APP_NAME_LOWERCASE}.hostname = \"PLACEHOLDER_ID-${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.image |= sub(\":.*$\", \":PLACEHOLDER_IMAGE_VERSION\")" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.restart = \"unless-stopped\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        echo "Extracting environment variables..."
        ENV_PATH=".services.${APP_NAME_LOWERCASE}.environment"
        if yq -e "${ENV_PATH}" "${TARGET_APP_DIR}/docker-compose.yaml" >/dev/null 2>&1; then
            ENV_TYPE=$(yq "${ENV_PATH} | type" "${TARGET_APP_DIR}/docker-compose.yaml")
            if [ "${ENV_TYPE}" == "!!seq" ]; then
                ENV_ITEMS=$(yq -r "${ENV_PATH}[]" "${TARGET_APP_DIR}/docker-compose.yaml")
            else
                ENV_ITEMS=$(yq -r "${ENV_PATH} | to_entries | .[] | .key + \"=\" + .value" "${TARGET_APP_DIR}/docker-compose.yaml")
            fi

            yq -i ".services.${APP_NAME_LOWERCASE}.environment = {}" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
            while IFS= read -r line; do
                [ -z "${line}" ] && continue
                KEY=${line%%=*}
                VALUE=${line#*=}
                KEY="${KEY}" VALUE="${VALUE}" yq -i ".services.${APP_NAME_LOWERCASE}.environment[env(KEY)] = env(VALUE)" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
            done <<< "${ENV_ITEMS}"
        fi
        yq -i ".services.${APP_NAME_LOWERCASE}.environment.TZ = \"PLACEHOLDER_TZ\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        yq -i 'sort_keys(..)' "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        echo "Replacing placeholders in docker-compose.yaml.j2..."
        sed -i 's/PLACEHOLDER_ID/{{ id }}/g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's/PLACEHOLDER_IMAGE_VERSION/{{ requested_image_version['${APP_NAME_LOWERCASE}'] }}/g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's/PLACEHOLDER_TZ/{{ timezone }}/g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's/PLACEHOLDER_DOCKER_SOCK/{{ docker_socket_path }}/g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"

    fi
elif [ "${MAINTYPE}" == "k8s" ]; then
    if [ -n "${SUBTYPE}" ] && [ -d "${REPO_ROOT}/_templates/${TYPE}" ]; then
        cp -r ${REPO_ROOT}/_templates/${TYPE}/* "${TARGET_APP_DIR}"
    fi
    if [ "${SUBTYPE}" == "truecharts" ]; then
        APP_PORT=$(curl -s https://raw.githubusercontent.com/trueforge-org/truecharts/refs/heads/master/charts/stable/${APP_NAME_LOWERCASE}/values.yaml | yq ".service.main.ports.main.port")
    elif [ "${SUBTYPE}" == "truecharts-local" ]; then
        # Check if there is an original truecharts available or not
        tags=$(curl -s https://oci.trueforge.org/v2/truecharts/${APP_NAME_LOWERCASE}/tags/list | jq .tags)
        if [ "${tags}" != "null" ]; then
            echo "WARNING: Official Truecharts chart found for ${APP_NAME_LOWERCASE}. Consider using 'k8s.truecharts' type instead."
        fi
        if [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
            echo "Gathering information from docker-compose.yaml for Truecharts values.yaml..."
            SERVICES=$(yq ".services | keys | .[]" "${TARGET_APP_DIR}/docker-compose.yaml")
            IMAGES=$(yq ".services[].image" "${TARGET_APP_DIR}/docker-compose.yaml")
            POSTGRESQL=$(yq '.services[].image | select(test("postgres"))' "${TARGET_APP_DIR}/docker-compose.yaml")
            echo "Converting docker-compose.yaml for Truecharts values.yaml..."
            echo > "${TARGET_APP_DIR}/app-values.yaml"
            if [ -n "${POSTGRESQL}" ]; then
              echo "Setting up a CNPG instance..."
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
              SINGLE_APP_SERVICE=${APP_SERVICES[0]}
              echo "Configuring application service '${SINGLE_APP_SERVICE}'..."
              echo "Extracting image..."
              APP_IMAGE=$(yq ".services.${SINGLE_APP_SERVICE}.image" "${TARGET_APP_DIR}/docker-compose.yaml")
              yq -i ".image.repository = \"${APP_IMAGE%%:*}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".image.tag = \"${APP_IMAGE##*:}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".image.pullPolicy = \"IfNotPresent\"" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Extracting volume mounts..."
              VOLUME_PATH=".services.${SINGLE_APP_SERVICE}.volumes"
              if yq -e "${VOLUME_PATH}" "${TARGET_APP_DIR}/docker-compose.yaml" >/dev/null 2>&1; then
                  VOLUME_ITEMS=$(yq -r "${VOLUME_PATH}[]" "${TARGET_APP_DIR}/docker-compose.yaml")

                  while IFS= read -r line; do
                      [ -z "${line}" ] && continue
                      CONTAINER_PATH=$(echo "${line}" | cut -d':' -f2)
                      yq -i ".persistence.data.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
                      yq -i ".persistence.data.accessModes = \"ReadWriteOnce\"" "${TARGET_APP_DIR}/app-values.yaml"
                      CONTAINER_PATH="${CONTAINER_PATH}" yq -i ".persistence.data.mountPath = env(CONTAINER_PATH)" "${TARGET_APP_DIR}/app-values.yaml"
                      yq -i ".persistence.data.type = \"pvc\"" "${TARGET_APP_DIR}/app-values.yaml"
                      yq -i ".persistence.data.size = \"1Gi\"" "${TARGET_APP_DIR}/app-values.yaml"
                  done <<< "${VOLUME_ITEMS}"
              fi

              echo "Extracting ports..."
              APP_PORT=$(yq ".services.${SINGLE_APP_SERVICE}.ports[0]" "${TARGET_APP_DIR}/docker-compose.yaml" | cut -d':' -f1)
              yq -i ".service.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.port = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.protocol = \"http\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.targetPort = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Setting timezone..."
              yq -i ".TZ = \"Europe/Budapest\"" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Preparing workload basics..."
              yq -i ".workload.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.type = \"Deployment\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.podSpec.containers.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Extracting environment variables..."
              ENV_PATH=".services.${SINGLE_APP_SERVICE}.environment"
              if yq -e "${ENV_PATH}" "${TARGET_APP_DIR}/docker-compose.yaml" >/dev/null 2>&1; then
                  ENV_TYPE=$(yq "${ENV_PATH} | type" "${TARGET_APP_DIR}/docker-compose.yaml")
                  if [ "${ENV_TYPE}" == "!!seq" ]; then
                      ENV_ITEMS=$(yq -r "${ENV_PATH}[]" "${TARGET_APP_DIR}/docker-compose.yaml")
                  else
                      ENV_ITEMS=$(yq -r "${ENV_PATH} | to_entries | .[] | .key + \"=\" + .value" "${TARGET_APP_DIR}/docker-compose.yaml")
                  fi

                  while IFS= read -r line; do
                      [ -z "${line}" ] && continue
                      KEY=${line%%=*}
                      VALUE=${line#*=}
                      KEY="${KEY}" VALUE="${VALUE}" yq -i ".workload.main.podSpec.containers.main.env[env(KEY)] = env(VALUE)" "${TARGET_APP_DIR}/app-values.yaml"
                  done <<< "${ENV_ITEMS}"
              fi

              echo "Preparing workload probes..."
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
