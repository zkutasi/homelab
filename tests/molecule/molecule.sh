#!/bin/bash

function usage() {
    echo "Usage: $0 [--changed <file>... | --list] [<role>...]"
    echo ""
    echo "Runs every Molecule scenario of the given roles (all roles with a molecule folder by default) inside the"
    echo "Ansible execution environment, against systemd containers built from tests/molecule/Dockerfile."
    echo ""
    echo "Options:"
    echo "  --changed     The arguments are changed files (relative to the repository root): test only the roles they belong"
    echo "                to and the roles whose scenarios use them, or all of them when the Molecule harness or the"
    echo "                execution environment changed"
    echo "  --help        Display this help message"
    echo "  --list        Only print which roles would be tested"
}

CHANGED=0
LIST=0
ARGS=()
while [ $# -ge 1 ]; do
  case "$1" in
    --changed)
      CHANGED=1
      ;;
    --help)
      usage
      exit 0
      ;;
    --list)
      LIST=1
      ;;
    --*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      ARGS+=("$1")
      ;;
  esac
  shift
done

REPO_ROOT=$(git rev-parse --show-toplevel)
ROLES_DIR="${REPO_ROOT}/automation/ansible/roles"

# The tested roles: every role with a molecule folder
ALL_ROLES=()
for MOLECULE_DIR in "${ROLES_DIR}"/*/molecule; do
  [ -d "${MOLECULE_DIR}" ] && ALL_ROLES+=("$(basename "$(dirname "${MOLECULE_DIR}")")")
done

ROLES=()
if [ "${CHANGED}" -eq 1 ]; then
  declare -A SELECTED
  for FILE in "${ARGS[@]}"; do
    case "${FILE}" in
      tests/molecule/*|automation/ansible/ansible-execution-environment/*)
        for ROLE in "${ALL_ROLES[@]}"; do SELECTED[${ROLE}]=1; done
        ;;
      automation/ansible/roles/*/*)
        CHANGED_ROLE=${FILE#automation/ansible/roles/}
        CHANGED_ROLE=${CHANGED_ROLE%%/*}
        # Its own scenarios, and the scenarios that run it (in prepare, for example)
        for ROLE in "${ALL_ROLES[@]}"; do
          if [ "${ROLE}" = "${CHANGED_ROLE}" ] \
              || grep -q -r -E "^\s*(- |name: )${CHANGED_ROLE}\s*$" "${ROLES_DIR}/${ROLE}/molecule"; then
            SELECTED[${ROLE}]=1
          fi
        done
        ;;
    esac
  done
  for ROLE in "${ALL_ROLES[@]}"; do
    [ -n "${SELECTED[${ROLE}]:-}" ] && ROLES+=("${ROLE}")
  done
  if [ "${#ROLES[@]}" -eq 0 ]; then
    echo "INFO: No Molecule scenario covers the changed files"
    exit 0
  fi
elif [ "${#ARGS[@]}" -gt 0 ]; then
  for ROLE in "${ARGS[@]}"; do
    if [ ! -d "${ROLES_DIR}/${ROLE}/molecule" ]; then
      echo "ERROR: role ${ROLE} has no Molecule scenarios"
      exit 1
    fi
  done
  ROLES=("${ARGS[@]}")
else
  ROLES=("${ALL_ROLES[@]}")
fi

if [ "${LIST}" -eq 1 ]; then
  printf '%s\n' "${ROLES[@]}"
  exit 0
fi

# The targets are built locally, and rebuilt only when their Dockerfile changes (its hash is a label of the image)
DOCKERFILE="${REPO_ROOT}/tests/molecule/Dockerfile"
DOCKERFILE_HASH=$(sha256sum "${DOCKERFILE}" | cut -c1-16)
# build_target <stage> <image>
function build_target() {
  local stage=$1 image=$2 old_image
  [ "$(docker image inspect -f '{{index .Config.Labels "homelab.dockerfile"}}' "${image}" 2>/dev/null)" = "${DOCKERFILE_HASH}" ] && return 0
  old_image=$(docker image inspect -f '{{.Id}}' "${image}" 2>/dev/null)
  echo "INFO: Building ${image}..."
  if ! docker build -q --target "${stage}" --label "homelab.dockerfile=${DOCKERFILE_HASH}" -t "${image}" - < "${DOCKERFILE}" > /dev/null; then
    echo "ERROR: Could not build ${image}"
    exit 1
  fi
  if [ -n "${old_image}" ] && [ "${old_image}" != "$(docker image inspect -f '{{.Id}}' "${image}")" ]; then
    docker rmi "${old_image}" > /dev/null 2>&1
  fi
}
build_target base homelab-molecule:testing
# The Docker target only when a selected role's scenarios use it
for ROLE in "${ROLES[@]}"; do
  if grep -q -r -F homelab-molecule-docker:testing "${ROLES_DIR}/${ROLE}/molecule"; then
    build_target docker homelab-molecule-docker:testing
    break
  fi
done

# Molecule drives the host's Docker through its socket, as the socket's group
EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
DOCKER_GID=$(stat -c %g /var/run/docker.sock)
TTY=()
[ -t 1 ] && TTY=(-t)
FAILED=()
for ROLE in "${ROLES[@]}"; do
  echo "INFO: Testing ${ROLE}..."
  docker run --rm "${TTY[@]}" --user "$(id -u):$(id -g)" --group-add "${DOCKER_GID}" -e HOME=/tmp \
    -v /var/run/docker.sock:/var/run/docker.sock -v "${REPO_ROOT}:/code" -w "/code/automation/ansible/roles/${ROLE}" \
    --entrypoint molecule "${EE_IMAGE}" -c /code/tests/molecule/config.yml test --all || FAILED+=("${ROLE}")
done
if [ "${#FAILED[@]}" -gt 0 ]; then
  echo "ERROR: Molecule failed for: ${FAILED[*]}"
  exit 1
fi
echo "INFO: All scenarios passed for: ${ROLES[*]}"
