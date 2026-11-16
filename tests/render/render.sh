#!/bin/bash

# renovate: datasource=docker depName=docker
DOCKER_CLI_VERSION="29.9.3-cli"

function usage() {
    echo "Usage: $0 [--changed <file>...]"
    echo ""
    echo "Renders every Docker App's docker-compose.yaml.j2 and config templates against the fake inventory in"
    echo "tests/render/inventory (one representative host per App, no host contacted), then checks the compose files."
    echo ""
    echo "Options:"
    echo "  --changed     The arguments are changed files (relative to the repository root): render only the Apps they belong"
    echo "                to, or all of them when the render harness or the docker-compose role changed"
    echo "  --help        Display this help message"
    echo "  --keep        Keep the work folder (rendered files, the generated playbook and its log) for debugging"
}

CHANGED=0
CHANGED_FILES=()
KEEP=0
while [ $# -ge 1 ]; do
  case "$1" in
    --changed)
      CHANGED=1
      ;;
    --help)
      usage
      exit 0
      ;;
    --keep)
      KEEP=1
      ;;
    --*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      CHANGED_FILES+=("$1")
      ;;
  esac
  shift
done
if [ "${CHANGED}" -eq 0 ] && [ "${#CHANGED_FILES[@]}" -gt 0 ]; then
  echo "ERROR: file arguments need --changed"
  usage
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
RENDER_DIR="${REPO_ROOT}/tests/render"

# The Docker Apps: every deploy playbook with a play using the docker-compose role, minus the skipped ones
mapfile -t PLAYBOOKS < <(cd "${REPO_ROOT}" && git grep -l -E '^\s+- docker-compose$' -- '*deploy*.yaml' ':!:_templates/**' | sort)
declare -A SKIP
while IFS=$'\t' read -r APP_DIR REASON; do
  [[ -z "${APP_DIR}" || "${APP_DIR}" == \#* ]] && continue
  SKIP[${APP_DIR}]=${REASON}
done < "${RENDER_DIR}/skip.tsv"

# --changed: an App is selected when one of its own files changed; the harness or the role select all of them
SELECTED=()
FULL=1
if [ "${CHANGED}" -eq 1 ]; then
  FULL=0
  for FILE in "${CHANGED_FILES[@]}"; do
    case "${FILE}" in
      tests/render/*|automation/ansible/roles/docker-compose/*|ansible.cfg)
        FULL=1
        ;;
    esac
  done
fi
for PLAYBOOK in "${PLAYBOOKS[@]}"; do
  APP_DIR=$(dirname "${PLAYBOOK}")
  [ -n "${SKIP[${APP_DIR}]+set}" ] && continue
  if [ "${FULL}" -eq 0 ]; then
    MATCH=0
    for FILE in "${CHANGED_FILES[@]}"; do
      [[ "${FILE}" == "${APP_DIR}"/* ]] && MATCH=1
    done
    [ "${MATCH}" -eq 0 ] && continue
  fi
  SELECTED+=("${PLAYBOOK}")
done
if [ "${#SELECTED[@]}" -eq 0 ]; then
  echo "INFO: No Docker App is affected by the changed files"
  exit 0
fi
echo "INFO: Rendering ${#SELECTED[@]} Docker App(s), ${#SKIP[@]} skipped (see tests/render/skip.tsv)"

WORK_DIR=$(mktemp -d)
if [ "${KEEP}" -eq 1 ]; then
  echo "INFO: Keeping the work folder ${WORK_DIR}"
else
  trap 'rm -rf "${WORK_DIR}"' EXIT
fi
mkdir -p "${WORK_DIR}/out"

# One play per App: its own vars, and only the first of its own hosts (the hosts pattern or expression, cut to one
# host), rendering what the role renders.
# A failure is written next to the output instead of failing the play, so the host stays in the later plays.
for PLAYBOOK in "${SELECTED[@]}"; do
  APP_DIR=$(dirname "${PLAYBOOK}")
  APP_DIR="${APP_DIR}" yq -o=json -I=0 '
    [.[] | select(.roles[]? == "docker-compose")][0] | {
      "name": "Render " + strenv(APP_DIR),
      "hosts": (
          (.hosts | select(tag == "!!seq") | "{{ query(\"inventory_hostnames\", \"" + join(",") + "\")[0:1] }}")
          // (.hosts | select(test("[{][{]")) | sub("^[{][{] *(.*?) *[}][}]$"; "{{ ([${1}] if (${1}) is string else (${1}))[0:1] }}"))
          // ("{{ query(\"inventory_hostnames\", \"" + .hosts + "\")[0:1] }}")),
      "gather_facts": false,
      "vars": (.vars + {"render_app_dir": strenv(APP_DIR)}),
      "tasks": [{"ansible.builtin.include_tasks": "/code/tests/render/render-app.yaml"}]
    }' "${REPO_ROOT}/${PLAYBOOK}"
done | jq -s '. + [{
    "name": "Write every host'"'"'s results at once",
    "hosts": "localhost",
    "gather_facts": false,
    "tasks": [{"name": "Write the results", "ansible.builtin.copy": {
      "content": "{{ groups[\"all\"] | map(\"extract\", hostvars) | map(attribute=\"render_results\", default={}) | combine | to_json }}",
      "dest": "/work/results.json", "mode": "0644"}}]
  }]' | yq -P '.' > "${WORK_DIR}/render.yaml"

# The docker-compose role's defaults come from an inventory of their own, loaded first: the fake inventory's values
# then win over them, as inventory values win over role defaults in a real run, and no role has to be evaluated
mkdir -p "${WORK_DIR}/defaults"
yq '{"all": {"vars": .}}' "${REPO_ROOT}/automation/ansible/roles/docker-compose/defaults/main.yaml" > "${WORK_DIR}/defaults/hosts.yaml"

EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
# Everything runs locally in the EE container; the extra vars beat the inventory's connection settings
docker run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -e ANSIBLE_CONFIG=/code/ansible.cfg -e ANSIBLE_CALLBACKS_ENABLED= -e ANSIBLE_ROLES_PATH=/code/automation/ansible/roles \
    -e ANSIBLE_LOCALHOST_WARNING=False -e ANSIBLE_INVENTORY_UNPARSED_WARNING=False \
    -v "${REPO_ROOT}:/code:ro" -v "${WORK_DIR}:/work" -w /work --entrypoint ansible-playbook "${EE_IMAGE}" \
    -i /work/defaults/hosts.yaml -i /code/tests/render/inventory /work/render.yaml \
    -e '{"ansible_connection": "local", "ansible_python_interpreter": "{{ ansible_playbook_python }}", "ansible_become": false}' \
    > "${WORK_DIR}/ansible.log" 2>&1
ANSIBLE_RC=$?
if [ "${ANSIBLE_RC}" -ne 0 ] || [ ! -f "${WORK_DIR}/results.json" ]; then
  echo "ERROR: ansible-playbook failed (exit ${ANSIBLE_RC}):"
  tail -20 "${WORK_DIR}/ansible.log"
  exit 1
fi

# Split the results into the App folders: out/<App>/docker-compose.yaml and out/<App>/config/<file>
FAILED=0
for PLAYBOOK in "${SELECTED[@]}"; do
  APP_DIR=$(dirname "${PLAYBOOK}")
  RESULT=$(jq -c --arg app "${APP_DIR}" '.[$app] // {"error": "nothing rendered (no host in its play?)"}' "${WORK_DIR}/results.json")
  if [ "$(jq 'has("error")' <<< "${RESULT}")" = "true" ]; then
    echo "FAIL ${APP_DIR}: rendering: $(jq -r '.error' <<< "${RESULT}" | head -c 400)"
    FAILED=1
    continue
  fi
  mkdir -p "${WORK_DIR}/out/${APP_DIR}/config"
  jq -r '.compose' <<< "${RESULT}" > "${WORK_DIR}/out/${APP_DIR}/docker-compose.yaml"
  jq '.expected' <<< "${RESULT}" > "${WORK_DIR}/out/${APP_DIR}/expected.json"
  while read -r NAME; do
    mkdir -p "$(dirname "${WORK_DIR}/out/${APP_DIR}/config/${NAME}")"
    jq -r --arg name "${NAME}" '.files[$name]' <<< "${RESULT}" > "${WORK_DIR}/out/${APP_DIR}/config/${NAME}"
  done < <(jq -r '.files | keys[]' <<< "${RESULT}")
done

# docker compose config validates every rendered compose file, in one container, one file per CPU at a time
docker run --rm --user "$(id -u):$(id -g)" -v "${WORK_DIR}/out:/out" -w /out --entrypoint sh "docker:${DOCKER_CLI_VERSION}" -c '
  find /out -name docker-compose.yaml | sort | xargs -r -n 1 -P "$(nproc)" sh -c '"'"'
    out=$(docker compose -f "$1" config --format json 2>&1) \
      && echo "${out}" > "${1%/*}/normalized.json" \
      || echo "FAIL ${1#/out/}: docker compose config: ${out}" | head -3'"'"' _' \
  > "${WORK_DIR}/compose.log"
if [ -s "${WORK_DIR}/compose.log" ]; then
  cat "${WORK_DIR}/compose.log"
  FAILED=1
fi

# The README's Docker App rules, minus the deviations accepted in allowlist.tsv
"${RENDER_DIR}/check-conventions.sh" "${WORK_DIR}/out" > "${WORK_DIR}/violations.tsv"
grep -v '^#' "${RENDER_DIR}/allowlist.tsv" | cut -f1-3 | sort -u > "${WORK_DIR}/allowed.tsv"
while IFS=$'\t' read -r APP SERVICE RULE DETAIL; do
  if ! grep -qxF "${APP}"$'\t'"${SERVICE}"$'\t'"${RULE}" "${WORK_DIR}/allowed.tsv"; then
    echo "FAIL ${APP} / ${SERVICE}: ${RULE}: ${DETAIL}"
    FAILED=1
  fi
done < "${WORK_DIR}/violations.tsv"
# An entry that matches no violation any more (fixed, renamed or removed) only hides a future mistake
if [ "${FULL}" -eq 1 ]; then
  cut -f1-3 "${WORK_DIR}/violations.tsv" | sort -u > "${WORK_DIR}/found.tsv"
  while IFS=$'\t' read -r APP SERVICE RULE; do
    if [ -z "${SKIP[${APP}]+set}" ] && ! grep -qxF "${APP}"$'\t'"${SERVICE}"$'\t'"${RULE}" "${WORK_DIR}/found.tsv"; then
      echo "FAIL allowlist.tsv: ${APP} / ${SERVICE} / ${RULE} matches nothing any more, remove it"
      FAILED=1
    fi
  done < "${WORK_DIR}/allowed.tsv"
fi

[ "${FAILED}" -eq 0 ] && echo "INFO: All ${#SELECTED[@]} App(s) rendered, passed docker compose config and follow the Docker App rules"
exit "${FAILED}"
