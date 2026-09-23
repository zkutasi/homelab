#!/bin/bash

APP_ABOUT=
APP_DOCKER_COMPOSE_URL=
APP_ENV_SECRET_PLACEHOLDERS=()
APP_FOLDERNAME=
APP_HOMEPAGE=
APP_IMAGE_REPO=
APP_IMAGE_TAG=
APP_NAME=
APP_NAME_LOWERCASE=
APP_PORT=
APP_SOURCE_URL=
APP_TARGET_DIR=

TYPE=docker
MAINTYPE=docker
SUBTYPE=

ANSIBLE_HOST=
INVENTORY=
REPO_ROOT=

MARIADB_CHART_VERSION="18.10.0"

function usage() {
  cat << EOF
Usage: $0 --foldername <foldername> --appname <appname> [--host <ansible_host>] [--type <docker|k8s>] [--docker-compose-url <url>] [--inventory <inventory>]

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
  --docker-compose-url <url>  Download docker-compose.yaml from the given URL into the foldername
                              instead of requiring one to already be present there
  --inventory <inventory>     Path to an Ansible inventory. When given, sensitive environment
                              variables discovered during kickstart are appended to its
                              group_vars/all file
EOF
}

# Retries only on connectivity-related curl exit codes (DNS failure, connection
# refused/no route to host, timeout, SSL connect error, empty/dropped reply).
# HTTP-level failures (e.g. -f getting a 404) are returned immediately, since
# retrying those would just waste time on a deterministic outcome.
function curl_with_retry() {
  local max_attempts=3
  local delay=2
  local attempt=1
  local exit_code=0

  while [ "${attempt}" -le "${max_attempts}" ]; do
    curl "$@"
    exit_code=$?

    case "${exit_code}" in
      6 | 7 | 28 | 35 | 52 | 56)
        if [ "${attempt}" -lt "${max_attempts}" ]; then
          echo "WARNING: curl connectivity issue (exit code ${exit_code}), retrying in ${delay}s (attempt ${attempt}/${max_attempts}) ..." >&2
          sleep "${delay}"
          delay=$((delay * 2))
        fi
        ;;
      *)
        return "${exit_code}"
        ;;
    esac

    attempt=$((attempt + 1))
  done

  return "${exit_code}"
}

function download_docker_compose() {
  [ -z "${APP_DOCKER_COMPOSE_URL}" ] && return

  if [[ "${APP_DOCKER_COMPOSE_URL}" == https://github.com/*/blob/* ]]; then
    APP_DOCKER_COMPOSE_URL=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -E 's#^https://github\.com/([^/]+)/([^/]+)/blob/(.+)$#https://raw.githubusercontent.com/\1/\2/\3#')
    echo "Converted GitHub blob URL to raw URL: '${APP_DOCKER_COMPOSE_URL}'"
  elif [[ "${APP_DOCKER_COMPOSE_URL}" == https://codeberg.org/*/src/* ]]; then
    APP_DOCKER_COMPOSE_URL=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -E 's#^https://codeberg\.org/([^/]+)/([^/]+)/src/(.+)$#https://codeberg.org/\1/\2/raw/\3#')
    echo "Converted Codeberg src URL to raw URL: '${APP_DOCKER_COMPOSE_URL}'"
  fi
  echo "Downloading docker-compose.yaml from '${APP_DOCKER_COMPOSE_URL}' ..."
  if ! curl_with_retry -sfL "${APP_DOCKER_COMPOSE_URL}" -o "${APP_TARGET_DIR}/docker-compose.yaml"; then
    echo "ERROR: Failed to download docker-compose.yaml from '${APP_DOCKER_COMPOSE_URL}'"
    exit 1
  fi

  if [[ "${APP_DOCKER_COMPOSE_URL}" == https://github.com/* || "${APP_DOCKER_COMPOSE_URL}" == https://raw.githubusercontent.com/* ]]; then
    local github_owner github_repo github_repo_info
    github_owner=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -nE 's#^https://(raw\.githubusercontent\.com|github\.com)/([^/]+)/([^/]+)/.*#\2#p')
    github_repo=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -nE 's#^https://(raw\.githubusercontent\.com|github\.com)/([^/]+)/([^/]+)/.*#\3#p')
    echo "Fetching repository information for '${github_owner}/${github_repo}' from GitHub ..."
    if github_repo_info=$(curl_with_retry -sf "https://api.github.com/repos/${github_owner}/${github_repo}"); then
      APP_ABOUT=$(echo "${github_repo_info}" | jq -r '
                (.description // "")
                | gsub("https?://\\S+"; "")
                | gsub("^\\s+|\\s+$"; "")
                | gsub("\\s{2,}"; " ")
            ')
      APP_HOMEPAGE=$(echo "${github_repo_info}" | jq -r '.homepage // empty')
      APP_SOURCE_URL="https://github.com/${github_owner}/${github_repo}"
    else
      echo "WARNING: Could not fetch repository information for '${github_owner}/${github_repo}' from GitHub."
    fi
  elif [[ "${APP_DOCKER_COMPOSE_URL}" == https://codeberg.org/* ]]; then
    local codeberg_owner codeberg_repo codeberg_repo_info
    codeberg_owner=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -nE 's#^https://codeberg\.org/([^/]+)/([^/]+)/.*#\1#p')
    codeberg_repo=$(echo "${APP_DOCKER_COMPOSE_URL}" | sed -nE 's#^https://codeberg\.org/([^/]+)/([^/]+)/.*#\2#p')
    echo "Fetching repository information for '${codeberg_owner}/${codeberg_repo}' from Codeberg ..."
    if codeberg_repo_info=$(curl_with_retry -sf "https://codeberg.org/api/v1/repos/${codeberg_owner}/${codeberg_repo}"); then
      APP_ABOUT=$(echo "${codeberg_repo_info}" | jq -r '
                (.description // "")
                | gsub("https?://\\S+"; "")
                | gsub("^\\s+|\\s+$"; "")
                | gsub("\\s{2,}"; " ")
            ')
      APP_HOMEPAGE=$(echo "${codeberg_repo_info}" | jq -r '.website // empty')
      APP_SOURCE_URL="https://codeberg.org/${codeberg_owner}/${codeberg_repo}"
    else
      echo "WARNING: Could not fetch repository information for '${codeberg_owner}/${codeberg_repo}' from Codeberg."
    fi
  else
    echo "NOTE: Populating README.md from the repository's About section is not implemented for this URL's host; only GitHub and Codeberg URLs are supported."
  fi
}

function preprocess_docker_compose() {
  [ -f "${APP_TARGET_DIR}/docker-compose.yaml" ] || return

  echo "Resolving env variable defaults in docker-compose.yaml ..."
  sed -i -E 's/\$\{[A-Za-z_][A-Za-z0-9_]*:?-([^}]*)\}/\1/g' "${APP_TARGET_DIR}/docker-compose.yaml"
}

function image_repo_link() {
  local image_path="${1%%:*}"

  case "${image_path}" in
    ghcr.io/*)
      local ghcr_rest="${image_path#ghcr.io/}"
      local owner="${ghcr_rest%%/*}"
      local package="${ghcr_rest#*/}"
      local repo="${package%%/*}"
      echo "https://github.com/${owner}/${repo}/pkgs/container/${package//\//%2F}"
      ;;
    docker.io/*/*)
      echo "https://hub.docker.com/r/${image_path#docker.io/}"
      ;;
    docker.io/*)
      echo "https://hub.docker.com/_/${image_path#docker.io/}"
      ;;
    */*/*)
      # Third-party registry (host-prefixed path) - not Docker Hub or GHCR, skip.
      ;;
    */*)
      echo "https://hub.docker.com/r/${image_path}"
      ;;
    *)
      echo "https://hub.docker.com/_/${image_path}"
      ;;
  esac
}

function populate_readme() {
  [ -f "${APP_TARGET_DIR}/README.md" ] || return

  if [ -n "${APP_SOURCE_URL}" ]; then
    echo "Populating README.md with information from '${APP_SOURCE_URL}' ..."
    [ -n "${APP_ABOUT}" ] && sed -i "s|^A short introduction of the app\$|${APP_ABOUT}|" "${APP_TARGET_DIR}/README.md"
    [ -n "${APP_HOMEPAGE}" ] && sed -i "s|^- ~~Official site~~\$|- [Official site](${APP_HOMEPAGE})|" "${APP_TARGET_DIR}/README.md"
    sed -i "s|^- ~~Source repository~~\$|- [Source repository](${APP_SOURCE_URL})|" "${APP_TARGET_DIR}/README.md"
  fi

  if [ -f "${APP_TARGET_DIR}/docker-compose.yaml" ]; then
    local service image link
    local -a services=()
    local -a links=()
    while IFS=$'\t' read -r service image; do
      [[ "${image}" =~ ^(postgres|redis|mysql|mariadb)(:|$|/) ]] && continue
      link=$(image_repo_link "${image}")
      if [ -n "${link}" ]; then
        services+=("${service}")
        links+=("${link}")
      fi
    done < <(yq -o=json '.services' "${APP_TARGET_DIR}/docker-compose.yaml" | jq -r 'to_entries[] | .key + "\t" + .value.image')

    if [ "${#links[@]}" -eq 1 ]; then
      sed -i "s|^- ~~Image repo~~\$|- [Image repo](${links[0]})|" "${APP_TARGET_DIR}/README.md"
    elif [ "${#links[@]}" -gt 1 ]; then
      sed -i "s|^- ~~Image repo~~\$|- Image repo:|" "${APP_TARGET_DIR}/README.md"
      local i
      for ((i = ${#links[@]} - 1; i >= 0; i--)); do
        sed -i "/^- Image repo:\$/a\\  - [${services[${i}]}](${links[${i}]})" "${APP_TARGET_DIR}/README.md"
      done
    fi
  fi

  if [ "${#APP_ENV_SECRET_PLACEHOLDERS[@]}" -gt 0 ]; then
    echo "Documenting sensitive environment variables in README.md ..."
    local -a var_names=()
    local entry
    for entry in "${APP_ENV_SECRET_PLACEHOLDERS[@]}"; do
      var_names+=("${entry#*=}")
    done

    local rows
    rows=$(printf '%s\n' "${var_names[@]}" | awk '!seen[$0]++ { printf "    |%s|M||\n", $0 }')
    rows="${rows}"$'\n'
    awk -v rows="${rows}" '
      { print }
      !inserted && /^    \|----\|------------------\|-------\|$/ { printf "%s", rows; inserted = 1 }
    ' "${APP_TARGET_DIR}/README.md" > "${APP_TARGET_DIR}/README.md.tmp" && mv "${APP_TARGET_DIR}/README.md.tmp" "${APP_TARGET_DIR}/README.md"
  fi
}

function populate_inventory() {
  [ -z "${INVENTORY}" ] && return
  [ "${#APP_ENV_SECRET_PLACEHOLDERS[@]}" -eq 0 ] && return

  local inventory_vars_file="${INVENTORY}/group_vars/all"
  if [ ! -f "${inventory_vars_file}" ]; then
    echo "WARNING: Inventory group_vars/all file not found at '${inventory_vars_file}'. Skipping."
    return
  fi

  echo "Appending sensitive environment variables into '${inventory_vars_file}' ..."
  local entry
  for entry in "${APP_ENV_SECRET_PLACEHOLDERS[@]}"; do
    echo "${entry#*=}:" >> "${inventory_vars_file}"
  done
}

function swap_out_templates() {
  echo "Swap out templates ..."
  # This must stay the last step that touches file content: everything it substitutes in (Jinja
  # "{{ x }}" among them) is valid-but-different YAML flow-mapping syntax, and any yq -i call after
  # this point would silently reparse and corrupt it, as would happen if it ran before all the yq
  # manipulation in the kickstart_* functions was done. Keep all such substitutions here so this
  # guarantee only needs to be reasoned about in one place.
  local line entry
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

    sed -i 's|PLACEHOLDER_ID|{{ id }}|g' "${line}"
    sed -i "s|PLACEHOLDER_IMAGE_VERSION|{{ requested_image_version['${APP_NAME_LOWERCASE}'] }}|g" "${line}"
    sed -i 's|PLACEHOLDER_PUID|{{ ansible_user_uid }}|g' "${line}"
    sed -i 's|PLACEHOLDER_GUID|{{ ansible_user_gid }}|g' "${line}"
    sed -i 's|PLACEHOLDER_TZ|{{ timezone }}|g' "${line}"
    sed -i 's|PLACEHOLDER_DOCKER_SOCK|{{ docker_socket_path }}|g' "${line}"
    sed -i 's|PLACEHOLDER_VOLUME_PATH|{{ docker_compose_rootdir }}/{{ docker_compose_projectname }}|g' "${line}"

    for entry in "${APP_ENV_SECRET_PLACEHOLDERS[@]}"; do
      sed -i "s|${entry%%=*}|{{ ${entry#*=} }}|" "${line}"
    done
  done < <(find "${APP_TARGET_DIR}" -type f)
}

function rename_files() {
  echo "Renaming files ..."
  if [[ "${TYPE}" == "binary" || "${TYPE}" == "docker" ]]; then
    mv "${APP_TARGET_DIR}/deploy.yaml" "${APP_TARGET_DIR}/deploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${APP_TARGET_DIR}/undeploy.yaml" "${APP_TARGET_DIR}/undeploy-${APP_NAME_LOWERCASE}.yaml"
    mv "${APP_TARGET_DIR}/config/templates/scrapeconfig-private.yaml.j2" "${APP_TARGET_DIR}/config/templates/scrapeconfig-${APP_NAME_LOWERCASE}-private.yaml.j2"
  fi
}

function kickstart_binary() {
  echo
}

function kickstart_docker() {
  if [ -f "${APP_TARGET_DIR}/docker-compose.yaml" ]; then
    echo "Processing existing docker-compose.yaml for templating ..."
    cp "${APP_TARGET_DIR}/docker-compose.yaml" "${APP_TARGET_DIR}/docker-compose.yaml.j2"

    local app_image
    app_image=$(yq -r ".services.${APP_NAME_LOWERCASE}.image" "${APP_TARGET_DIR}/docker-compose.yaml.j2")
    APP_IMAGE_REPO=${app_image%%:*}
    APP_IMAGE_TAG=${app_image##*:}
    yq -i ".services.${APP_NAME_LOWERCASE}.container_name = \"${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.hostname = \"PLACEHOLDER_ID-${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.image = \"PLACEHOLDER_IMAGE_VERSION\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.restart = \"unless-stopped\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"

    echo "Processing environment variables ..."
    local env_path env_type env_items line key value
    env_path=".services.${APP_NAME_LOWERCASE}.environment"
    if yq -e "${env_path}" "${APP_TARGET_DIR}/docker-compose.yaml" > /dev/null 2>&1; then
      env_type=$(yq "${env_path} | type" "${APP_TARGET_DIR}/docker-compose.yaml")
      if [ "${env_type}" == "!!seq" ]; then
        env_items=$(yq -r "${env_path}[]" "${APP_TARGET_DIR}/docker-compose.yaml")
      else
        env_items=$(yq -r "${env_path} | to_entries | .[] | .key + \"=\" + .value" "${APP_TARGET_DIR}/docker-compose.yaml")
      fi

      yq -i ".services.${APP_NAME_LOWERCASE}.environment = {}" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
      while IFS= read -r line; do
        [ -z "${line}" ] && continue
        key=${line%%=*}
        value=${line#*=}
        KEY="${key}" VALUE="${value}" yq -i ".services.${APP_NAME_LOWERCASE}.environment[env(KEY)] = env(VALUE)" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
      done <<< "${env_items}"
    fi
    yq -i ".services.${APP_NAME_LOWERCASE}.environment.PUID = \"PLACEHOLDER_PUID\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.environment.PGID = \"PLACEHOLDER_GUID\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
    yq -i ".services.${APP_NAME_LOWERCASE}.environment.TZ = \"PLACEHOLDER_TZ\"" "${APP_TARGET_DIR}/docker-compose.yaml.j2"

    echo "Processing volumes ..."
    local volume_path volume_items index from to
    volume_path=".services.${APP_NAME_LOWERCASE}.volumes"
    if yq -e "${volume_path}" "${APP_TARGET_DIR}/docker-compose.yaml" > /dev/null 2>&1; then
      volume_items=$(yq -r "${volume_path}[]" "${APP_TARGET_DIR}/docker-compose.yaml")

      yq -i ".services.${APP_NAME_LOWERCASE}.volumes = []" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
      index=0
      while IFS= read -r line; do
        [ -z "${line}" ] && continue
        from=${line%%:*}
        if [[ "${from}" == "/var/run/docker.sock"* ]]; then
          from="PLACEHOLDER_DOCKER_SOCK"
        else
          from="PLACEHOLDER_VOLUME_PATH/${from}"
        fi
        to=${line#*:}
        INDEX="${index}" FROM="${from}" TO="${to}" yq -i ".services.${APP_NAME_LOWERCASE}.volumes[env(INDEX)] = env(FROM) + \":\" + env(TO)" "${APP_TARGET_DIR}/docker-compose.yaml.j2"
        index=$((index + 1))
      done <<< "${volume_items}"
    fi

    yq -i 'sort_keys(..)' "${APP_TARGET_DIR}/docker-compose.yaml.j2"
  fi
}

function kickstart_k8s_truecharts() {
  local truecharts_values
  if truecharts_values=$(curl_with_retry -sf "https://raw.githubusercontent.com/trueforge-org/truecharts/refs/heads/master/charts/stable/${APP_NAME_LOWERCASE}/values.yaml"); then
    APP_PORT=$(echo "${truecharts_values}" | yq ".service.main.ports.main.port")
  else
    echo "WARNING: Could not fetch upstream Truecharts values.yaml for '${APP_NAME_LOWERCASE}' (network error or chart not found). The <APP_PORT> placeholder will remain unresolved."
  fi
}

function kickstart_k8s_truecharts_local() {
  local tags_response tags
  # Check if there is an original truecharts available or not
  if tags_response=$(curl_with_retry -s "https://oci.trueforge.org/v2/truecharts/${APP_NAME_LOWERCASE}/tags/list"); then
    tags=$(echo "${tags_response}" | jq .tags)
    if [ "${tags}" != "null" ]; then
      echo "WARNING: Official Truecharts chart found for ${APP_NAME_LOWERCASE}. Consider using 'k8s.truecharts' type instead."
    fi
  else
    echo "WARNING: Could not reach oci.trueforge.org to check for an official Truecharts chart (network error). Skipping this check."
  fi
  if [ -f "${APP_TARGET_DIR}/docker-compose.yaml" ]; then
    echo "Gathering information from docker-compose.yaml for Truecharts values.yaml ..."
    local services images postgresql mariadb
    services=$(yq ".services | keys | .[]" "${APP_TARGET_DIR}/docker-compose.yaml")
    images=$(yq ".services[].image" "${APP_TARGET_DIR}/docker-compose.yaml")
    postgresql=$(yq '.services[].image | select(test("postgres"))' "${APP_TARGET_DIR}/docker-compose.yaml")
    mariadb=$(yq '.services[].image | select(test("mysql|mariadb"))' "${APP_TARGET_DIR}/docker-compose.yaml")
    echo "Converting docker-compose.yaml for Truecharts values.yaml ..."
    echo > "${APP_TARGET_DIR}/app-values.yaml"
    echo > "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
    if [ -n "${postgresql}" ]; then
      echo "Setting up a CNPG instance ..."
      yq -i ".cnpg.main.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".cnpg.main.cluster.instances = 1" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
      yq -i ".cnpg.main.cluster.singleNode = true" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
      yq -i ".cnpg.main.cluster.storage.size = \"2Gi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
      yq -i ".cnpg.main.cluster.walStorage.size = \"2Gi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
      yq -i ".cnpg.main.database = \"${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".cnpg.main.monitoring.enablePodMonitor = true" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".cnpg.main.user = \"${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/app-values.yaml"
    fi
    if [ -n "${mariadb}" ]; then
      echo "Setting up a MariaDB instance ..."
      yq -i ".mariadb.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".mariadb.mariadbUsername = \"${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".mariadb.mariadbDatabase = \"${APP_NAME_LOWERCASE}\"" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".mariadb.persistence.data.size = \"1Gi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
      if [ -f "${APP_TARGET_DIR}/chart/Chart.yaml" ]; then
        yq -i ".dependencies += [{\"name\": \"mariadb\", \"version\": \"${MARIADB_CHART_VERSION}\", \"repository\": \"oci://oci.trueforge.org/truecharts\", \"condition\": \"mariadb.enabled\", \"alias\": \"\", \"tags\": [], \"import-values\": []}]" "${APP_TARGET_DIR}/chart/Chart.yaml"
      fi
    fi

    if [ -n "${postgresql}" ] || [ -n "${mariadb}" ]; then
      echo "Generating secrets configuration scaffolding ..."
      if [ -n "${postgresql}" ]; then
        yq -i ".cnpg.main.password = \"PLACEHOLDER_DB_PASSWORD\"" "${APP_TARGET_DIR}/config/templates/app-values-private.yaml.j2"
      fi
      if [ -n "${mariadb}" ]; then
        yq -i ".mariadb.password = \"PLACEHOLDER_DB_PASSWORD\"" "${APP_TARGET_DIR}/config/templates/app-values-private.yaml.j2"
        yq -i ".mariadb.rootPassword = \"PLACEHOLDER_DB_ROOTPASSWORD\"" "${APP_TARGET_DIR}/config/templates/app-values-private.yaml.j2"
      fi

      APP_ENV_SECRET_PLACEHOLDERS+=("PLACEHOLDER_DB_PASSWORD=${APP_NAME_LOWERCASE}_database_password")
      [ -n "${mariadb}" ] && APP_ENV_SECRET_PLACEHOLDERS+=("PLACEHOLDER_DB_ROOTPASSWORD=${APP_NAME_LOWERCASE}_database_rootpassword")
    fi

    local -a app_services
    app_services=($(yq '.services | with_entries( select(.value.image | test("postgres|redis|mysql|mariadb") | not) ) | keys[]' "${APP_TARGET_DIR}/docker-compose.yaml"))
    if (( ${#app_services[@]} >= 1 )); then
      local multi_container=false
      (( ${#app_services[@]} > 1 )) && multi_container=true

      local -a container_keys=()
      local -a image_selectors=()
      local service_index service
      for service_index in "${!app_services[@]}"; do
        service=${app_services[$service_index]}
        if [ "${service_index}" -eq 0 ]; then
          container_keys+=("main")
          if [ "${multi_container}" = true ]; then
            image_selectors+=("${APP_NAME_LOWERCASE}Image")
          else
            image_selectors+=("image")
          fi
        else
          container_keys+=("${service}")
          image_selectors+=("${service}Image")
        fi
      done

      echo "Processing images ..."
      local image_selector service_image service_image_repo service_image_tag
      for service_index in "${!app_services[@]}"; do
        service=${app_services[$service_index]}
        image_selector=${image_selectors[$service_index]}
        service_image=$(yq ".services.${service}.image" "${APP_TARGET_DIR}/docker-compose.yaml")
        service_image_repo=${service_image%%:*}
        service_image_tag=${service_image##*:}
        yq -i ".${image_selector}.repository = \"${service_image_repo}\"" "${APP_TARGET_DIR}/app-values.yaml"
        yq -i ".${image_selector}.tag = \"${service_image_tag}\"" "${APP_TARGET_DIR}/app-values.yaml"
        yq -i ".${image_selector}.pullPolicy = \"IfNotPresent\"" "${APP_TARGET_DIR}/app-values.yaml"
        if [ "${service_index}" -eq 0 ]; then
          APP_IMAGE_REPO=${service_image_repo}
          APP_IMAGE_TAG=${service_image_tag}
        fi
      done

      echo "Processing volume mounts ..."
      local container_key volume_path volume_items persistence_base_key volume_index persistence_key container_path line
      for service_index in "${!app_services[@]}"; do
        service=${app_services[$service_index]}
        container_key=${container_keys[$service_index]}
        volume_path=".services.${service}.volumes"
        if yq -e "${volume_path}" "${APP_TARGET_DIR}/docker-compose.yaml" > /dev/null 2>&1; then
          volume_items=$(yq -r "${volume_path}[]" "${APP_TARGET_DIR}/docker-compose.yaml")
          if [ "${service_index}" -eq 0 ]; then
            persistence_base_key="data"
          else
            persistence_base_key="${container_key}-data"
          fi

          volume_index=0
          while IFS= read -r line; do
            [ -z "${line}" ] && continue
            volume_index=$((volume_index + 1))
            if [ "${volume_index}" -eq 1 ]; then
              persistence_key="${persistence_base_key}"
            else
              persistence_key="${persistence_base_key}-${volume_index}"
            fi
            container_path=$(echo "${line}" | cut -d':' -f2)
            yq -i ".persistence.${persistence_key}.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
            yq -i ".persistence.${persistence_key}.accessModes = \"ReadWriteOnce\"" "${APP_TARGET_DIR}/app-values.yaml"
            CONTAINER_PATH="${container_path}" yq -i ".persistence.${persistence_key}.mountPath = env(CONTAINER_PATH)" "${APP_TARGET_DIR}/app-values.yaml"
            yq -i ".persistence.${persistence_key}.type = \"pvc\"" "${APP_TARGET_DIR}/app-values.yaml"
            yq -i ".persistence.${persistence_key}.size = \"1Gi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
          done <<< "${volume_items}"
        fi
      done

      echo "Processing ports ..."
      local app_port_raw
      app_port_raw=$(yq ".services.${app_services[0]}.ports[0]" "${APP_TARGET_DIR}/docker-compose.yaml")
      app_port_raw=${app_port_raw%%/*}
      APP_PORT=${app_port_raw##*:}
      yq -i ".service.main.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".service.main.ports.main.port = ${APP_PORT}" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".service.main.ports.main.protocol = \"http\"" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".service.main.ports.main.targetPort = ${APP_PORT}" "${APP_TARGET_DIR}/app-values.yaml"

      echo "Processing timezone ..."
      yq -i ".TZ = \"Europe/Budapest\"" "${APP_TARGET_DIR}/app-values.yaml"

      echo "Processing workload ..."
      yq -i ".workload.main.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
      yq -i ".workload.main.type = \"Deployment\"" "${APP_TARGET_DIR}/app-values.yaml"
      local is_primary env_path env_type env_items key value env_var_name placeholder
      for service_index in "${!app_services[@]}"; do
        service=${app_services[$service_index]}
        container_key=${container_keys[$service_index]}
        image_selector=${image_selectors[$service_index]}
        is_primary=false
        [ "${service_index}" -eq 0 ] && is_primary=true
        echo "Configuring workload container '${container_key}' (service '${service}') ..."

        yq -i ".workload.main.podSpec.containers.${container_key}.enabled = true" "${APP_TARGET_DIR}/app-values.yaml"
        if [ "${multi_container}" = true ]; then
          yq -i ".workload.main.podSpec.containers.${container_key}.imageSelector = \"${image_selector}\"" "${APP_TARGET_DIR}/app-values.yaml"
        fi

        env_path=".services.${service}.environment"
        if yq -e "${env_path}" "${APP_TARGET_DIR}/docker-compose.yaml" > /dev/null 2>&1; then
          echo "Processing environment variables for container '${container_key}' ..."
          env_type=$(yq "${env_path} | type" "${APP_TARGET_DIR}/docker-compose.yaml")
          if [ "${env_type}" == "!!seq" ]; then
            env_items=$(yq -r "${env_path}[]" "${APP_TARGET_DIR}/docker-compose.yaml")
          else
            env_items=$(yq -r "${env_path} | to_entries | .[] | .key + \"=\" + .value" "${APP_TARGET_DIR}/docker-compose.yaml")
          fi

          while IFS= read -r line; do
            [ -z "${line}" ] && continue
            key=${line%%=*}
            value=${line#*=}
            echo "Found environment variable '${key}' ..."
            if [[ "${key}" =~ SECRET|PASSWORD ]]; then
              echo "Routing sensitive environment variable '${key}' into app-values-private.yaml.j2 instead of app-values.yaml ..."
              env_var_name="${APP_NAME_LOWERCASE}_$(echo "${key}" | tr '[:upper:]' '[:lower:]')"
              placeholder="PLACEHOLDER_ENV_SECRET_${key}"
              KEY="${key}" PLACEHOLDER="${placeholder}" yq -i ".workload.main.podSpec.containers.${container_key}.env[env(KEY)] = env(PLACEHOLDER)" "${APP_TARGET_DIR}/config/templates/app-values-private.yaml.j2"
              APP_ENV_SECRET_PLACEHOLDERS+=("${placeholder}=${env_var_name}")
            else
              KEY="${key}" VALUE="${value}" yq -i ".workload.main.podSpec.containers.${container_key}.env[env(KEY)] = env(VALUE)" "${APP_TARGET_DIR}/app-values.yaml"
            fi
          done <<< "${env_items}"
        fi
        if [ "${is_primary}" = true ] && [ -n "${postgresql}" ]; then
          yq -i ".workload.main.podSpec.containers.${container_key}.env.DATABASE_URL.secretKeyRef.name = \"cnpg-main-urls\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.DATABASE_URL.secretKeyRef.key = \"std\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_HOST.secretKeyRef.name = \"cnpg-main-urls\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_HOST.secretKeyRef.key = \"host\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_USER.secretKeyRef.name = \"cnpg-main-user\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_USER.secretKeyRef.key = \"username\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_PASSWORD.secretKeyRef.name = \"cnpg-main-user\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.POSTGRES_PASSWORD.secretKeyRef.key = \"password\"" "${APP_TARGET_DIR}/app-values.yaml"
        fi
        if [ "${is_primary}" = true ] && [ -n "${mariadb}" ]; then
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_HOST.secretKeyRef.expandObjectName = false" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_HOST.secretKeyRef.name = \"${APP_NAME_LOWERCASE}-mariadbcreds\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_HOST.secretKeyRef.key = \"plainhost\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_PASSWORD.secretKeyRef.expandObjectName = false" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_PASSWORD.secretKeyRef.name = \"${APP_NAME_LOWERCASE}-mariadbcreds\"" "${APP_TARGET_DIR}/app-values.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.env.MYSQL_PASSWORD.secretKeyRef.key = \"mariadb-password\"" "${APP_TARGET_DIR}/app-values.yaml"
        fi

        yq -i ".workload.main.podSpec.containers.${container_key}.probes.liveness.enabled = false" "${APP_TARGET_DIR}/app-values.yaml"
        yq -i ".workload.main.podSpec.containers.${container_key}.probes.readiness.enabled = false" "${APP_TARGET_DIR}/app-values.yaml"
        yq -i ".workload.main.podSpec.containers.${container_key}.probes.startup.enabled = false" "${APP_TARGET_DIR}/app-values.yaml"

        if [ "${is_primary}" = true ]; then
          yq -i ".workload.main.podSpec.containers.${container_key}.resources.requests.cpu = \"10m\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.resources.requests.memory = \"50Mi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.resources.limits.cpu = \"1\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
          yq -i ".workload.main.podSpec.containers.${container_key}.resources.limits.memory = \"1Gi\"" "${APP_TARGET_DIR}/app-values-dimensioning.yaml"
        fi
      done

      echo "Adding spacing between top-level sections ..."
      sed -i '2,$ s/^\([A-Za-z0-9_.-]\)/\n\1/' "${APP_TARGET_DIR}/app-values.yaml"
    fi
  fi
}

function kickstart_k8s() {
  if [ -n "${SUBTYPE}" ] && [ -d "${REPO_ROOT}/_templates/${TYPE}" ]; then
    cp -r "${REPO_ROOT}/_templates/${TYPE}"/* "${APP_TARGET_DIR}"
  fi
  mkdir -p "${APP_TARGET_DIR}/config/templates"
  echo > "${APP_TARGET_DIR}/config/templates/app-values-private.yaml.j2"
  if [ "${SUBTYPE}" == "truecharts" ]; then
    kickstart_k8s_truecharts
  elif [ "${SUBTYPE}" == "truecharts-local" ]; then
    kickstart_k8s_truecharts_local
  fi
}

function check_and_set_variables() {
  [ -z "${APP_FOLDERNAME}" ] && echo "ERROR: No foldername specified" && usage && exit 1
  [ -z "${APP_NAME}" ] && echo "ERROR: No appname specified" && usage && exit 1

  if [[ "${MAINTYPE}" != "binary" && "${MAINTYPE}" != "docker" && "${MAINTYPE}" != "k8s" ]]; then
    echo "ERROR: Invalid type specified. Allowed values are 'binary', 'docker' or 'k8s'."
    usage
    exit 1
  fi

  local -a required_commands=("yq" "curl" "jq")

  local -a missing_commands=()
  local cmd
  for cmd in "${required_commands[@]}"; do
    command -v "${cmd}" > /dev/null 2>&1 || missing_commands+=("${cmd}")
  done
  if [ "${#missing_commands[@]}" -gt 0 ]; then
    echo "ERROR: Missing required command(s): ${missing_commands[*]}"
    echo "Please install them and try again."
    exit 1
  fi

  REPO_ROOT="."
  if command -v git > /dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
  fi

  APP_TARGET_DIR="${REPO_ROOT}/${APP_FOLDERNAME}"

  if [[ "${MAINTYPE}" == "docker" || "${TYPE}" == "k8s.truecharts-local" ]] && [ -z "${APP_DOCKER_COMPOSE_URL}" ] && [ ! -f "${APP_TARGET_DIR}/docker-compose.yaml" ]; then
    echo "ERROR: No docker-compose.yaml found in '${APP_TARGET_DIR}' and no --docker-compose-url specified."
    usage
    exit 1
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
      APP_NAME_LOWERCASE=$(echo "${APP_NAME}" | tr '[:upper:]' '[:lower:]')
      ;;
    --host)
      shift
      ANSIBLE_HOST=$1
      ;;
    --docker-compose-url)
      shift
      APP_DOCKER_COMPOSE_URL=$1
      ;;
    --inventory)
      shift
      INVENTORY=$1
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

check_and_set_variables

echo "Preparing to kickstart app '${APP_NAME}' in folder '${APP_FOLDERNAME}' using '${TYPE}' templates."
mkdir -p "${APP_TARGET_DIR}"

echo "Copy files ..."
cp -r "${REPO_ROOT}/_templates/${MAINTYPE}"/* "${APP_TARGET_DIR}"

download_docker_compose
preprocess_docker_compose

if [ "${MAINTYPE}" == "binary" ]; then
  kickstart_binary
elif [ "${MAINTYPE}" == "docker" ]; then
  kickstart_docker
elif [ "${MAINTYPE}" == "k8s" ]; then
  kickstart_k8s
fi

populate_readme
populate_inventory

swap_out_templates
rename_files

echo "Deleting docker-compose.yaml file ..."
rm -rf "${APP_TARGET_DIR}/docker-compose.yaml"

echo
echo "=============================================================================================================="
echo "Kickstart completed successfully for app '${APP_NAME}' in folder '${APP_FOLDERNAME}'."
echo "Double-check '${APP_TARGET_DIR}' for any remaining <PLACEHOLDER> tokens or unfinished sections and fill them in manually."
