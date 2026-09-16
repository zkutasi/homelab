#!/bin/bash

APP_NAME=
APP_NAME_LOWERCASE=
APP_FOLDERNAME=
ANSIBLE_HOST=
TYPE=docker
MAINTYPE=docker
SUBTYPE=
# Pinned TrueCharts mariadb dependency version for generated Chart.yaml files; Renovate's helmv3
# manager tracks chart/Chart.yaml dependencies natively once written, no special comment needed.
MARIADB_CHART_VERSION="18.10.0"

function usage() {
    cat <<EOF
Usage: $0 --foldername <foldername> --appname <appname> [--host <ansible_host>] [--type <docker|k8s>]

Options:
  --foldername <foldername>   Specify the folder to create (required)
  --appname <appname>         Specify the application name to use as a replacement (required)
  --host <ansible_host>       Specify the Ansible host for deployment
  --type <type>               Specify the template type. Default: docker
                              can be either of the following:
                              - binary               : for binary and service based deployments
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
      APP_NAME_LOWERCASE=$(echo "${APP_NAME}" | tr '[:upper:]' '[:lower:]')
      ;;
    --host)
      shift
      ANSIBLE_HOST=$1
      ;;
    --type)
      shift
      TYPE=$1
      MAINTYPE=$(echo "${TYPE}" | awk -F. '{print $1}')
      SUBTYPE=$(echo "${TYPE}" | awk -F. '{print $2}')
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

if [[ "${MAINTYPE}" != "binary" && "${MAINTYPE}" != "docker" && "${MAINTYPE}" != "k8s" ]]; then
    echo "ERROR: Invalid type specified. Allowed values are 'binary', 'docker' or 'k8s'."
    usage
    exit 1
fi

REQUIRED_COMMANDS=("yq" "curl" "jq")

MISSING_COMMANDS=()
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    command -v "${cmd}" >/dev/null 2>&1 || MISSING_COMMANDS+=("${cmd}")
done
if [ "${#MISSING_COMMANDS[@]}" -gt 0 ]; then
    echo "ERROR: Missing required command(s): ${MISSING_COMMANDS[*]}"
    echo "Please install them and try again."
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
cp -r "${REPO_ROOT}/_templates/${MAINTYPE}"/* "${TARGET_APP_DIR}"

if [ "${MAINTYPE}" == "binary" ]; then
  echo
elif [ "${MAINTYPE}" == "docker" ]; then
    if [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
        echo "Processing existing docker-compose.yaml for templating..."
        cp "${TARGET_APP_DIR}/docker-compose.yaml" "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        APP_IMAGE=$(yq -r ".services.${APP_NAME_LOWERCASE}.image" "${TARGET_APP_DIR}/docker-compose.yaml.j2")
        APP_IMAGE_REPO=${APP_IMAGE%%:*}
        APP_IMAGE_TAG=${APP_IMAGE##*:}
        yq -i ".services.${APP_NAME_LOWERCASE}.container_name = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.hostname = \"PLACEHOLDER_ID-${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.image = \"PLACEHOLDER_IMAGE_VERSION\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.restart = \"unless-stopped\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        echo "Processing environment variables..."
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
        yq -i ".services.${APP_NAME_LOWERCASE}.environment.PUID = \"PLACEHOLDER_PUID\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.environment.PGID = \"PLACEHOLDER_GUID\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        yq -i ".services.${APP_NAME_LOWERCASE}.environment.TZ = \"PLACEHOLDER_TZ\"" "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        echo "Processing volumes..."
        VOLUME_PATH=".services.${APP_NAME_LOWERCASE}.volumes"
        if yq -e "${VOLUME_PATH}" "${TARGET_APP_DIR}/docker-compose.yaml" >/dev/null 2>&1; then
            VOLUME_ITEMS=$(yq -r "${VOLUME_PATH}[]" "${TARGET_APP_DIR}/docker-compose.yaml")

            yq -i ".services.${APP_NAME_LOWERCASE}.volumes = []" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
            INDEX=0
            while IFS= read -r line; do
                [ -z "${line}" ] && continue
                FROM=${line%%:*}
                if [[ "${FROM}" == "/var/run/docker.sock"* ]]; then
                    FROM="PLACEHOLDER_DOCKER_SOCK"
                else
                    FROM="PLACEHOLDER_VOLUME_PATH/${FROM}"
                fi
                TO=${line#*:}
                INDEX="${INDEX}" FROM="${FROM}" TO="${TO}" yq -i ".services.${APP_NAME_LOWERCASE}.volumes[env(INDEX)] = env(FROM) + \":\" + env(TO)" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
                INDEX=$((INDEX + 1))
            done <<< "${VOLUME_ITEMS}"
        fi

        yq -i 'sort_keys(..)' "${TARGET_APP_DIR}/docker-compose.yaml.j2"

        echo "Replacing placeholders in docker-compose.yaml.j2..."
        sed -i 's|PLACEHOLDER_ID|{{ id }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i "s|PLACEHOLDER_IMAGE_VERSION|{{ requested_image_version['${APP_NAME_LOWERCASE}'] }}|g" "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's|PLACEHOLDER_PUID|{{ ansible_user_uid }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's|PLACEHOLDER_GUID|{{ ansible_user_gid }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's|PLACEHOLDER_TZ|{{ timezone }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's|PLACEHOLDER_DOCKER_SOCK|{{ docker_socket_path }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
        sed -i 's|PLACEHOLDER_VOLUME_PATH|{{ docker_compose_rootdir }}/{{ docker_compose_projectname }}|g' "${TARGET_APP_DIR}/docker-compose.yaml.j2"
    fi
elif [ "${MAINTYPE}" == "k8s" ]; then
    if [ -n "${SUBTYPE}" ] && [ -d "${REPO_ROOT}/_templates/${TYPE}" ]; then
        cp -r "${REPO_ROOT}/_templates/${TYPE}"/* "${TARGET_APP_DIR}"
    fi
    mkdir -p "${TARGET_APP_DIR}/config/templates"
    echo > "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
    if [ "${SUBTYPE}" == "truecharts" ]; then
        if TRUECHARTS_VALUES=$(curl -sf "https://raw.githubusercontent.com/trueforge-org/truecharts/refs/heads/master/charts/stable/${APP_NAME_LOWERCASE}/values.yaml"); then
            APP_PORT=$(echo "${TRUECHARTS_VALUES}" | yq ".service.main.ports.main.port")
        else
            echo "WARNING: Could not fetch upstream Truecharts values.yaml for '${APP_NAME_LOWERCASE}' (network error or chart not found). The <APP_PORT> placeholder will remain unresolved."
        fi
    elif [ "${SUBTYPE}" == "truecharts-local" ]; then
        # Check if there is an original truecharts available or not
        if tags_response=$(curl -s "https://oci.trueforge.org/v2/truecharts/${APP_NAME_LOWERCASE}/tags/list"); then
            tags=$(echo "${tags_response}" | jq .tags)
            if [ "${tags}" != "null" ]; then
                echo "WARNING: Official Truecharts chart found for ${APP_NAME_LOWERCASE}. Consider using 'k8s.truecharts' type instead."
            fi
        else
            echo "WARNING: Could not reach oci.trueforge.org to check for an official Truecharts chart (network error). Skipping this check."
        fi
        if [ -f "${TARGET_APP_DIR}/docker-compose.yaml" ]; then
            echo "Gathering information from docker-compose.yaml for Truecharts values.yaml..."
            SERVICES=$(yq ".services | keys | .[]" "${TARGET_APP_DIR}/docker-compose.yaml")
            IMAGES=$(yq ".services[].image" "${TARGET_APP_DIR}/docker-compose.yaml")
            POSTGRESQL=$(yq '.services[].image | select(test("postgres"))' "${TARGET_APP_DIR}/docker-compose.yaml")
            MARIADB=$(yq '.services[].image | select(test("mysql|mariadb"))' "${TARGET_APP_DIR}/docker-compose.yaml")
            echo "Converting docker-compose.yaml for Truecharts values.yaml..."
            echo > "${TARGET_APP_DIR}/app-values.yaml"
            echo > "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
            if [ -n "${POSTGRESQL}" ]; then
              echo "Setting up a CNPG instance..."
              yq -i ".cnpg.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.cluster.instances = 1" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
              yq -i ".cnpg.main.cluster.singleNode = true" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
              yq -i ".cnpg.main.cluster.storage.size = \"2Gi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
              yq -i ".cnpg.main.cluster.walStorage.size = \"2Gi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
              yq -i ".cnpg.main.database = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.monitoring.enablePodMonitor = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".cnpg.main.user = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
            fi
            if [ -n "${MARIADB}" ]; then
              echo "Setting up a MariaDB instance..."
              yq -i ".mariadb.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".mariadb.mariadbUsername = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".mariadb.mariadbDatabase = \"${APP_NAME_LOWERCASE}\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".mariadb.persistence.data.size = \"1Gi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
              if [ -f "${TARGET_APP_DIR}/chart/Chart.yaml" ]; then
                yq -i ".dependencies += [{\"name\": \"mariadb\", \"version\": \"${MARIADB_CHART_VERSION}\", \"repository\": \"oci://oci.trueforge.org/truecharts\", \"condition\": \"mariadb.enabled\", \"alias\": \"\", \"tags\": [], \"import-values\": []}]" "${TARGET_APP_DIR}/chart/Chart.yaml"
              fi
            fi

            if [ -n "${POSTGRESQL}" ] || [ -n "${MARIADB}" ]; then
              echo "Generating secrets configuration scaffolding..."
              if [ -n "${POSTGRESQL}" ]; then
                yq -i ".cnpg.main.password = \"PLACEHOLDER_DB_PASSWORD\"" "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
              fi
              if [ -n "${MARIADB}" ]; then
                yq -i ".mariadb.password = \"PLACEHOLDER_DB_PASSWORD\"" "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
                yq -i ".mariadb.rootPassword = \"PLACEHOLDER_DB_ROOTPASSWORD\"" "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
              fi
              sed -i "s|PLACEHOLDER_DB_PASSWORD|{{ ${APP_NAME_LOWERCASE}_database_password }}|g" "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
              sed -i "s|PLACEHOLDER_DB_ROOTPASSWORD|{{ ${APP_NAME_LOWERCASE}_database_rootpassword }}|g" "${TARGET_APP_DIR}/config/templates/app-values-private.yaml.j2"
            fi

            APP_SERVICES=($(yq '.services | with_entries( select(.value.image | test("postgres|redis|mysql|mariadb") | not) ) | keys[]' "${TARGET_APP_DIR}/docker-compose.yaml"))
            if (( ${#APP_SERVICES[@]} >= 1 )); then
              MULTI_CONTAINER=false
              (( ${#APP_SERVICES[@]} > 1 )) && MULTI_CONTAINER=true

              CONTAINER_KEYS=()
              IMAGE_SELECTORS=()
              for SERVICE_INDEX in "${!APP_SERVICES[@]}"; do
                SERVICE=${APP_SERVICES[$SERVICE_INDEX]}
                if [ "${SERVICE_INDEX}" -eq 0 ]; then
                  CONTAINER_KEYS+=("main")
                  if [ "${MULTI_CONTAINER}" = true ]; then
                    IMAGE_SELECTORS+=("${APP_NAME_LOWERCASE}Image")
                  else
                    IMAGE_SELECTORS+=("image")
                  fi
                else
                  CONTAINER_KEYS+=("${SERVICE}")
                  IMAGE_SELECTORS+=("${SERVICE}Image")
                fi
              done

              echo "Processing images..."
              for SERVICE_INDEX in "${!APP_SERVICES[@]}"; do
                SERVICE=${APP_SERVICES[$SERVICE_INDEX]}
                IMAGE_SELECTOR=${IMAGE_SELECTORS[$SERVICE_INDEX]}
                SERVICE_IMAGE=$(yq ".services.${SERVICE}.image" "${TARGET_APP_DIR}/docker-compose.yaml")
                SERVICE_IMAGE_REPO=${SERVICE_IMAGE%%:*}
                SERVICE_IMAGE_TAG=${SERVICE_IMAGE##*:}
                yq -i ".${IMAGE_SELECTOR}.repository = \"${SERVICE_IMAGE_REPO}\"" "${TARGET_APP_DIR}/app-values.yaml"
                yq -i ".${IMAGE_SELECTOR}.tag = \"${SERVICE_IMAGE_TAG}\"" "${TARGET_APP_DIR}/app-values.yaml"
                yq -i ".${IMAGE_SELECTOR}.pullPolicy = \"IfNotPresent\"" "${TARGET_APP_DIR}/app-values.yaml"
                if [ "${SERVICE_INDEX}" -eq 0 ]; then
                  APP_IMAGE_REPO=${SERVICE_IMAGE_REPO}
                  APP_IMAGE_TAG=${SERVICE_IMAGE_TAG}
                fi
              done

              echo "Processing volume mounts..."
              for SERVICE_INDEX in "${!APP_SERVICES[@]}"; do
                SERVICE=${APP_SERVICES[$SERVICE_INDEX]}
                CONTAINER_KEY=${CONTAINER_KEYS[$SERVICE_INDEX]}
                VOLUME_PATH=".services.${SERVICE}.volumes"
                if yq -e "${VOLUME_PATH}" "${TARGET_APP_DIR}/docker-compose.yaml" >/dev/null 2>&1; then
                    VOLUME_ITEMS=$(yq -r "${VOLUME_PATH}[]" "${TARGET_APP_DIR}/docker-compose.yaml")
                    if [ "${SERVICE_INDEX}" -eq 0 ]; then
                      PERSISTENCE_BASE_KEY="data"
                    else
                      PERSISTENCE_BASE_KEY="${CONTAINER_KEY}-data"
                    fi

                    VOLUME_INDEX=0
                    while IFS= read -r line; do
                        [ -z "${line}" ] && continue
                        VOLUME_INDEX=$((VOLUME_INDEX + 1))
                        if [ "${VOLUME_INDEX}" -eq 1 ]; then
                          PERSISTENCE_KEY="${PERSISTENCE_BASE_KEY}"
                        else
                          PERSISTENCE_KEY="${PERSISTENCE_BASE_KEY}-${VOLUME_INDEX}"
                        fi
                        CONTAINER_PATH=$(echo "${line}" | cut -d':' -f2)
                        yq -i ".persistence.${PERSISTENCE_KEY}.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
                        yq -i ".persistence.${PERSISTENCE_KEY}.accessModes = \"ReadWriteOnce\"" "${TARGET_APP_DIR}/app-values.yaml"
                        CONTAINER_PATH="${CONTAINER_PATH}" yq -i ".persistence.${PERSISTENCE_KEY}.mountPath = env(CONTAINER_PATH)" "${TARGET_APP_DIR}/app-values.yaml"
                        yq -i ".persistence.${PERSISTENCE_KEY}.type = \"pvc\"" "${TARGET_APP_DIR}/app-values.yaml"
                        yq -i ".persistence.${PERSISTENCE_KEY}.size = \"1Gi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
                    done <<< "${VOLUME_ITEMS}"
                fi
              done

              echo "Processing ports..."
              APP_PORT_RAW=$(yq ".services.${APP_SERVICES[0]}.ports[0]" "${TARGET_APP_DIR}/docker-compose.yaml")
              APP_PORT_RAW=${APP_PORT_RAW%%/*}
              APP_PORT=${APP_PORT_RAW##*:}
              yq -i ".service.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.port = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.protocol = \"http\"" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".service.main.ports.main.targetPort = ${APP_PORT}" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Processing timezone..."
              yq -i ".TZ = \"Europe/Budapest\"" "${TARGET_APP_DIR}/app-values.yaml"

              echo "Processing workload..."
              yq -i ".workload.main.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
              yq -i ".workload.main.type = \"Deployment\"" "${TARGET_APP_DIR}/app-values.yaml"
              for SERVICE_INDEX in "${!APP_SERVICES[@]}"; do
                SERVICE=${APP_SERVICES[$SERVICE_INDEX]}
                CONTAINER_KEY=${CONTAINER_KEYS[$SERVICE_INDEX]}
                IMAGE_SELECTOR=${IMAGE_SELECTORS[$SERVICE_INDEX]}
                IS_PRIMARY=false
                [ "${SERVICE_INDEX}" -eq 0 ] && IS_PRIMARY=true
                echo "Configuring workload container '${CONTAINER_KEY}' (service '${SERVICE}')..."

                yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.enabled = true" "${TARGET_APP_DIR}/app-values.yaml"
                if [ "${MULTI_CONTAINER}" = true ]; then
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.imageSelector = \"${IMAGE_SELECTOR}\"" "${TARGET_APP_DIR}/app-values.yaml"
                fi

                ENV_PATH=".services.${SERVICE}.environment"
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
                        KEY="${KEY}" VALUE="${VALUE}" yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env[env(KEY)] = env(VALUE)" "${TARGET_APP_DIR}/app-values.yaml"
                    done <<< "${ENV_ITEMS}"
                fi
                if [ "${IS_PRIMARY}" = true ] && [ -n "${POSTGRESQL}" ]; then
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.DATABASE_URL.secretKeyRef.name = \"cnpg-main-urls\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.DATABASE_URL.secretKeyRef.key = \"std\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_HOST.secretKeyRef.name = \"cnpg-main-urls\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_HOST.secretKeyRef.key = \"host\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_USER.secretKeyRef.name = \"cnpg-main-user\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_USER.secretKeyRef.key = \"username\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_PASSWORD.secretKeyRef.name = \"cnpg-main-user\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.POSTGRES_PASSWORD.secretKeyRef.key = \"password\"" "${TARGET_APP_DIR}/app-values.yaml"
                fi
                if [ "${IS_PRIMARY}" = true ] && [ -n "${MARIADB}" ]; then
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_HOST.secretKeyRef.expandObjectName = false" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_HOST.secretKeyRef.name = \"${APP_NAME_LOWERCASE}-mariadbcreds\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_HOST.secretKeyRef.key = \"plainhost\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_PASSWORD.secretKeyRef.expandObjectName = false" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_PASSWORD.secretKeyRef.name = \"${APP_NAME_LOWERCASE}-mariadbcreds\"" "${TARGET_APP_DIR}/app-values.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.env.MYSQL_PASSWORD.secretKeyRef.key = \"mariadb-password\"" "${TARGET_APP_DIR}/app-values.yaml"
                fi

                yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.probes.liveness.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"
                yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.probes.readiness.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"
                yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.probes.startup.enabled = false" "${TARGET_APP_DIR}/app-values.yaml"

                if [ "${IS_PRIMARY}" = true ]; then
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.resources.requests.cpu = \"10m\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.resources.requests.memory = \"50Mi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.resources.limits.cpu = \"1\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
                  yq -i ".workload.main.podSpec.containers.${CONTAINER_KEY}.resources.limits.memory = \"1Gi\"" "${TARGET_APP_DIR}/app-values-dimensioning.yaml"
                fi
              done

              echo "Adding spacing between top-level sections..."
              sed -i '2,$ s/^\([A-Za-z0-9_.-]\)/\n\1/' "${TARGET_APP_DIR}/app-values.yaml"
            fi
        fi
    fi
fi

echo "Swap out templates..."
while read -r line; do
  sed -i "s|<APP_NAME_LOWERCASE>|${APP_NAME_LOWERCASE}|g" "${line}"
  sed -i "s|<APP_IMAGE_REPO>|${APP_IMAGE_REPO}|g" "${line}"
  sed -i "s|<APP_IMAGE_TAG>|${APP_IMAGE_TAG}|g" "${line}"
  sed -i "s|<APP_NAME>|${APP_NAME}|g" "${line}"
  sed -i "s|<APP_FOLDERNAME>|${APP_FOLDERNAME}|g" "${line}"
  if [ -n "${ANSIBLE_HOST}" ]; then
    sed -i "s|<ANSIBLE_HOST>|${ANSIBLE_HOST}|g" "${line}"
  fi
  if [ -n "${APP_PORT}" ]; then
    sed -i "s|<APP_PORT>|${APP_PORT}|g" "${line}"
  fi
done < <(find "${TARGET_APP_DIR}" -type f)

echo "Renaming files..."
if [[ "${TYPE}" == "binary" || "${TYPE}" == "docker" ]]; then
    mv "${TARGET_APP_DIR}/deploy.yaml" "${TARGET_APP_DIR}/deploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${TARGET_APP_DIR}/undeploy.yaml" "${TARGET_APP_DIR}/undeploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${TARGET_APP_DIR}/config/templates/scrapeconfig-private.yaml.j2" "${TARGET_APP_DIR}/config/templates/scrapeconfig-${APP_NAME_LOWERCASE}-private.yaml.j2"
fi

echo "Kickstart completed successfully for app '${APP_NAME}' in folder '${APP_FOLDERNAME}'."
echo "Double-check '${TARGET_APP_DIR}' for any remaining <PLACEHOLDER> tokens or unfinished sections and fill them in manually."
