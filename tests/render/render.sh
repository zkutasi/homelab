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

# The Docker Apps: every deploy playbook with a play using the docker-compose role (`- docker-compose`, or
# `- role: docker-compose` with options such as a `when`), minus the skipped ones
mapfile -t PLAYBOOKS < <(cd "${REPO_ROOT}" && git grep -l -E '^\s+- (role: )?docker-compose$' -- '*deploy*.yaml' ':!:_templates/**' | sort)
declare -A SKIP
while IFS=$'\t' read -r APP_DIR REASON; do
  [[ -z "${APP_DIR}" || "${APP_DIR}" == \#* ]] && continue
  SKIP[${APP_DIR}]=${REASON}
done < "${RENDER_DIR}/skip.tsv"
# Other playbooks whose template tasks write an App's config, listed with what they write
mapfile -t CONFIG_PLAYBOOKS < <(grep -v '^#' "${RENDER_DIR}/playbooks.tsv" | cut -f1)

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
# A full run covers every compose template: an App the selection above misses fails instead of passing unseen
if [ "${FULL}" -eq 1 ]; then
  declare -A COVERED
  for PLAYBOOK in "${PLAYBOOKS[@]}"; do COVERED[$(dirname "${PLAYBOOK}")]=1; done
  while read -r APP_DIR; do
    if [ -z "${COVERED[${APP_DIR}]+set}" ] && [ -z "${SKIP[${APP_DIR}]+set}" ]; then
      echo "FAIL ${APP_DIR}: has a docker-compose.yaml.j2, but no deploy playbook using the docker-compose role was found"
      UNCOVERED=1
    fi
  done < <(cd "${REPO_ROOT}" && git ls-files '*docker-compose.yaml.j2' ':!:_templates/**' ':!:tests/**' | xargs -r -n 1 dirname | sort -u)
fi
CONFIG_SELECTED=()
for PLAYBOOK in "${CONFIG_PLAYBOOKS[@]}"; do
  if [ "${FULL}" -eq 0 ]; then
    MATCH=0
    for FILE in "${CHANGED_FILES[@]}"; do
      [[ "${FILE}" == "$(dirname "${PLAYBOOK}")"/* ]] && MATCH=1
    done
    [ "${MATCH}" -eq 0 ] && continue
  fi
  CONFIG_SELECTED+=("${PLAYBOOK}")
done
if [ $((${#SELECTED[@]} + ${#CONFIG_SELECTED[@]})) -eq 0 ]; then
  echo "INFO: No Docker App is affected by the changed files"
  exit 0
fi
echo "INFO: Rendering ${#SELECTED[@]} Docker App(s), ${#SKIP[@]} skipped (see tests/render/skip.tsv)," \
  "and the templates of ${#CONFIG_SELECTED[@]} other playbook(s) (see tests/render/playbooks.tsv)"

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
    ([.[] | select(.roles[]? == "docker-compose")] + [.[] | select(.roles[]?.role? == "docker-compose")])[0] | {
      "name": "Render " + strenv(APP_DIR),
      "hosts": (
          (.hosts | select(tag == "!!seq") | "{{ query(\"inventory_hostnames\", \"" + join(",") + "\")[0:1] }}")
          // (.hosts | select(test("[{][{]")) | sub("^[{][{] *(.*?) *[}][}]$"; "{{ ([${1}] if (${1}) is string else (${1}) | sort)[0:1] }}"))
          // ("{{ query(\"inventory_hostnames\", \"" + .hosts + "\")[0:1] }}")),
      "gather_facts": false,
      "vars": (.vars + {"render_app_dir": strenv(APP_DIR)}),
      "tasks": [{"ansible.builtin.include_tasks": "/code/tests/render/render-app.yaml"}]
    }' "${REPO_ROOT}/${PLAYBOOK}"
done > "${WORK_DIR}/plays.jsonl"
# The other playbooks: every play with template tasks, cut to one host, renders them with the play's and the task's
# vars, keyed by the template's path below config/templates
for PLAYBOOK in "${CONFIG_SELECTED[@]}"; do
  CONFIG_PLAYBOOK="${PLAYBOOK}" CONFIG_DIR=$(dirname "${PLAYBOOK}") yq -o=json -I=0 '
    .[] | select([.tasks[]? | has("ansible.builtin.template")] | any) | {
      "name": "Render the templates of " + strenv(CONFIG_PLAYBOOK),
      "hosts": (
          (.hosts | select(. == "localhost"))
          // (.hosts | select(tag == "!!seq") | "{{ query(\"inventory_hostnames\", \"" + join(",") + "\")[0:1] }}")
          // ("{{ query(\"inventory_hostnames\", \"" + .hosts + "\")[0:1] }}")),
      "gather_facts": false,
      "vars": ((.vars // {}) + {"render_playbook": strenv(CONFIG_PLAYBOOK)}),
      "tasks": [{
        "block": [.tasks[] | select(has("ansible.builtin.template")) | .["ansible.builtin.template"].src as $src | {
          "name": "Render " + $src,
          "ansible.builtin.set_fact": {"render_results": "{{ render_results | default({}) | combine({render_playbook: {\"files\": {\""
            + ($src | sub("^config/templates/"; "") | sub("\\.j2$"; "")) + "\": lookup(\"ansible.builtin.template\", \"/code/"
            + strenv(CONFIG_DIR) + "/" + $src + "\", convert_data=False)}}}, recursive=True) }}"},
          "vars": (.vars // {})}],
        "rescue": [{"name": "Record the failure", "ansible.builtin.set_fact": {"render_results":
          "{{ render_results | default({}) | combine({render_playbook: {\"error\": ansible_failed_task.name ~ \": \" ~ (ansible_failed_result.msg | default(\"unknown error\"))}}) }}"}}]
      }]
    }' "${REPO_ROOT}/${PLAYBOOK}"
done >> "${WORK_DIR}/plays.jsonl"
jq -s '. + [{
    "name": "Write every host'"'"'s results at once",
    "hosts": "localhost",
    "gather_facts": false,
    "tasks": [{"name": "Write the results", "ansible.builtin.copy": {
      "content": "{{ (groups[\"all\"] + [\"localhost\"]) | map(\"extract\", hostvars) | map(attribute=\"render_results\", default={}) | combine | to_json }}",
      "dest": "/work/results.json", "mode": "0644"}}]
  }]' "${WORK_DIR}/plays.jsonl" | yq -P '.' > "${WORK_DIR}/render.yaml"

# The docker-compose role's defaults come from an inventory of their own, loaded first: the fake inventory's values
# then win over them, as inventory values win over role defaults in a real run, and no role has to be evaluated
mkdir -p "${WORK_DIR}/defaults"
yq '{"all": {"vars": .}}' "${REPO_ROOT}/automation/ansible/roles/docker-compose/defaults/main.yaml" > "${WORK_DIR}/defaults/hosts.yaml"

EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
# Everything runs locally in the EE container; the extra vars beat the inventory's connection settings
docker run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -e ANSIBLE_CONFIG=/code/ansible.cfg -e ANSIBLE_CALLBACKS_ENABLED=ansible.builtin.default -e ANSIBLE_ROLES_PATH=/code/automation/ansible/roles \
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

# Split the results into the output folders in one jq pass of NUL-separated records: a failure, or a file's path and
# content. Apps: out/<App>/docker-compose.yaml, expected.json and config/<file>; the other playbooks:
# out/<playbook without .yaml>/config/<file>
FAILED=${UNCOVERED:-0}
TARGETS=$({
  for PLAYBOOK in "${SELECTED[@]}"; do printf '%s\t%s\n' "$(dirname "${PLAYBOOK}")" "$(dirname "${PLAYBOOK}")"; done
  for PLAYBOOK in "${CONFIG_SELECTED[@]}"; do printf '%s\t%s\n' "${PLAYBOOK}" "${PLAYBOOK%.yaml}"; done
} | jq -R -s 'split("\n")[:-1] | map(split("\t") | {key: .[0], out: .[1]})')
while IFS= read -r -d '' KIND && IFS= read -r -d '' TARGET && IFS= read -r -d '' CONTENT; do
  if [ "${KIND}" = error ]; then
    echo "FAIL ${TARGET}: rendering: ${CONTENT:0:400}"
    FAILED=1
  else
    mkdir -p "$(dirname "${WORK_DIR}/out/${TARGET}")"
    printf '%s\n' "${CONTENT}" > "${WORK_DIR}/out/${TARGET}"
  fi
done < <(jq -j --argjson targets "${TARGETS}" '. as $results | $targets[] | . as $t
    | ($results[$t.key] // {"error": "nothing rendered (no host in its play?)"}) as $r
    | if $r.error then ["error", $t.key, $r.error]
      else (if $r.compose then ["file", $t.out + "/docker-compose.yaml", $r.compose],
              ["file", $t.out + "/expected.json", ($r.expected | tojson)] else empty end),
           ($r.files | to_entries[] | ["file", $t.out + "/config/" + .key, .value])
      end
    | map(. + "\u0000") | add' "${WORK_DIR}/results.json")

# The rendered config files in a format with a parser: YAML through yq, JSON through jq; the others stay unchecked
while read -r FILE; do
  case "${FILE}" in
    *.json) ERROR=$(jq empty "${FILE}" 2>&1) ;;
    *) ERROR=$(yq '.' "${FILE}" 2>&1 > /dev/null) ;;
  esac
  if [ -n "${ERROR}" ]; then
    echo "FAIL ${FILE#"${WORK_DIR}"/out/}: ${ERROR}" | head -3
    FAILED=1
  fi
done < <(find "${WORK_DIR}/out" -path '*/config/*' -type f \( -name '*.yaml' -o -name '*.yml' -o -name '*.json' \) | sort)

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

# Docker refuses two containers with the same name on one host, so no two Apps may share a container_name
if [ "${FULL}" -eq 1 ]; then
  while read -r NORMALIZED; do
    APP=${NORMALIZED#"${WORK_DIR}"/out/}
    jq -r --arg app "${APP%/normalized.json}" '.services[] | select(.container_name) | [.container_name, $app] | @tsv' "${NORMALIZED}"
  done < <(find "${WORK_DIR}/out" -name normalized.json | sort) \
    | awk -F '\t' '{ apps[$1] = apps[$1] " " $2; count[$1]++ }
        END { for (name in count) if (count[name] > 1) print "FAIL container_name " name " is used by:" apps[name] }' \
    > "${WORK_DIR}/duplicates.log"
  if [ -s "${WORK_DIR}/duplicates.log" ]; then
    cat "${WORK_DIR}/duplicates.log"
    FAILED=1
  fi
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
