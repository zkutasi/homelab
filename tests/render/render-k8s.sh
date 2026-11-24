#!/bin/bash

# The CRD schemas for kubeconform, from one commit of the CRDs-catalog
# renovate: datasource=git-refs depName=https://github.com/datreeio/CRDs-catalog currentValue=main
CRDS_CATALOG_COMMIT="784ec895547a36e548e6810b41f27baade3a0890"

function usage() {
    echo "Usage: $0 [--changed <file>...]"
    echo ""
    echo "Generates the private files of every Kubernetes App from the fake inventory in tests/render/inventory, the way"
    echo "its generate-configuration.yaml does, into a copy of the App's folder in a work folder, then renders each Helm"
    echo "or Kustomize App there through its own deploy-k8s.sh --template-output, for the cluster's Kubernetes version."
    echo "Then kubeconform -strict validates the renders and every App's extra manifests (CRD schemas from the pinned"
    echo "CRDs-catalog), and check-k8s-conventions.sh checks the Kubernetes App rules, minus allowlist-k8s.tsv."
    echo "Neither the repository nor any host or cluster is touched; chart and schema downloads need the network and are"
    echo "cached in ${HOME}/.cache/homelab-tests. Apps in skip-k8s.tsv are left out."
    echo ""
    echo "Options:"
    echo "  --changed     The arguments are changed files (relative to the repository root): handle only the Apps they"
    echo "                belong to, or all of them when the render harness, a common-*.sh helper or the"
    echo "                Kubernetes version (kubernetes/k8s-install/kubespray/run-upgrade.sh) changed"
    echo "  --help        Display this help message"
    echo "  --keep        Keep the work folder (the App copies, the generated playbook and its log) for debugging"
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

# The Kubernetes Apps: every folder with a deploy-k8s.sh, minus the skipped ones
mapfile -t APP_DIRS < <(cd "${REPO_ROOT}" && git ls-files -- '*/deploy-k8s.sh' ':!:_templates/**' ':!:tests/**' | xargs -r -n 1 dirname | sort)
declare -A SKIP
while IFS=$'\t' read -r APP_DIR REASON; do
  [[ -z "${APP_DIR}" || "${APP_DIR}" == \#* ]] && continue
  SKIP[${APP_DIR}]=${REASON}
done < "${RENDER_DIR}/skip-k8s.tsv"

# --changed: an App is selected when one of its own files changed, a file belonging to the deepest App folder that
# holds it (App folders can be nested, like kubernetes/ and the Apps below it); the harness, a helper or the
# Kubernetes version select all
FULL=1
declare -A CHANGED_APPS
if [ "${CHANGED}" -eq 1 ]; then
  FULL=0
  for FILE in "${CHANGED_FILES[@]}"; do
    case "${FILE}" in
      tests/render/*|common-*.sh|ansible.cfg|kubernetes/k8s-install/kubespray/run-upgrade.sh)
        FULL=1
        ;;
    esac
    OWNER=
    for APP_DIR in "${APP_DIRS[@]}"; do
      [[ "${FILE}" == "${APP_DIR}"/* && ${#APP_DIR} -gt ${#OWNER} ]] && OWNER=${APP_DIR}
    done
    [ -n "${OWNER}" ] && CHANGED_APPS[${OWNER}]=1
  done
fi
SELECTED=()
for APP_DIR in "${APP_DIRS[@]}"; do
  [ -n "${SKIP[${APP_DIR}]+set}" ] && continue
  [ "${FULL}" -eq 0 ] && [ -z "${CHANGED_APPS[${APP_DIR}]+set}" ] && continue
  SELECTED+=("${APP_DIR}")
done
if [ "${#SELECTED[@]}" -eq 0 ]; then
  echo "INFO: No Kubernetes App is affected by the changed files"
  exit 0
fi
echo "INFO: Handling ${#SELECTED[@]} Kubernetes App(s), ${#SKIP[@]} skipped (see tests/render/skip-k8s.tsv)"

WORK_DIR=$(mktemp -d)
if [ "${KEEP}" -eq 1 ]; then
  echo "INFO: Keeping the work folder ${WORK_DIR}"
else
  trap 'rm -rf "${WORK_DIR}"' EXIT
fi

# The work copy: the committed files of each App (never the real private files), plus the root helpers. Symlinks
# are copied as links, never followed, and the ones to the internal CA's certificate and key become dummy files, so
# the real CA key is never read.
mkdir -p "${WORK_DIR}/repo"
(cd "${REPO_ROOT}" && git ls-files -z -- "${SELECTED[@]}" 'common-*.sh' | xargs -0 cp -P --parents -t "${WORK_DIR}/repo") || exit 1
while IFS= read -r -d '' LINK; do
  if [[ "$(readlink "${LINK}")" == */security/certificates/certs/* ]]; then
    rm -f "${LINK}"
    echo "DUMMY $(basename "${LINK}") FOR THE RENDER TESTS" > "${LINK}"
  fi
done < <(find "${WORK_DIR}/repo" -type l -print0)

# One playbook per App with a generate playbook, next to it in the copy, so that its relative paths (template
# sources, file lookups) resolve in the App's copied folder: the source and target of each of its template tasks
for APP_DIR in "${SELECTED[@]}"; do
  [ -f "${REPO_ROOT}/${APP_DIR}/generate-configuration.yaml" ] || continue
  export APP_DIR
  yq -P '[{
      "name": "Generate " + strenv(APP_DIR),
      "hosts": "localhost",
      "gather_facts": false,
      "tasks": [{"ansible.builtin.include_tasks": "/code/tests/render/generate-app.yaml",
        "vars": {"render_app_dir": strenv(APP_DIR),
          "render_templates": [.[].tasks[] | select(has("ansible.builtin.template")) | .["ansible.builtin.template"] | {"src": .src, "dest": .dest}]}}]
    }]' "${REPO_ROOT}/${APP_DIR}/generate-configuration.yaml" > "${WORK_DIR}/repo/${APP_DIR}/render-generate.yaml"
  echo "- ansible.builtin.import_playbook: /work/repo/${APP_DIR}/render-generate.yaml"
done > "${WORK_DIR}/generate.yaml"
cat >> "${WORK_DIR}/generate.yaml" << 'EOF'
- name: Write the results
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Write the results
      ansible.builtin.copy:
        content: "{{ render_results | default({}) | to_json }}"
        dest: /work/results.json
        mode: "0644"
    - name: Write the internal domain, for the rule checks
      ansible.builtin.copy:
        content: "{{ kubernetes_internal_domain }}"
        dest: /work/internal-domain
        mode: "0644"
EOF

EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
docker run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -e ANSIBLE_CONFIG=/code/ansible.cfg -e ANSIBLE_CALLBACKS_ENABLED=ansible.builtin.default \
    -e ANSIBLE_LOCALHOST_WARNING=False -e ANSIBLE_INVENTORY_UNPARSED_WARNING=False \
    -v "${REPO_ROOT}:/code:ro" -v "${WORK_DIR}:/work" -w /work --entrypoint ansible-playbook "${EE_IMAGE}" \
    -i /code/tests/render/inventory /work/generate.yaml \
    -e '{"ansible_connection": "local", "ansible_python_interpreter": "{{ ansible_playbook_python }}", "ansible_become": false}' \
    > "${WORK_DIR}/ansible.log" 2>&1
ANSIBLE_RC=$?
if [ "${ANSIBLE_RC}" -ne 0 ] || [ ! -f "${WORK_DIR}/results.json" ]; then
  echo "ERROR: ansible-playbook failed (exit ${ANSIBLE_RC}):"
  tail -20 "${WORK_DIR}/ansible.log"
  exit 1
fi

# Write each App's generated files into its copy, at the generate playbook's own target paths
FAILED=0
GENERATED=0
while IFS=$'\t' read -r APP_DIR KIND VALUE; do
  if [ "${KIND}" = "error" ]; then
    echo "FAIL ${APP_DIR}: generating: ${VALUE:0:400}"
    FAILED=1
    continue
  fi
  mkdir -p "$(dirname "${WORK_DIR}/repo/${APP_DIR}/${VALUE}")"
  jq -r --arg app "${APP_DIR}" --arg dest "${VALUE}" '.[$app].files[$dest]' "${WORK_DIR}/results.json" > "${WORK_DIR}/repo/${APP_DIR}/${VALUE}"
  GENERATED=$((GENERATED + 1))
done < <(jq -r 'to_entries[] | .key as $app | if .value.error then [$app, "error", (.value.error | gsub("[\t\n]"; " "))]
    else (.value.files | keys[] | [$app, "file", .]) end | @tsv' "${WORK_DIR}/results.json")

[ "${FAILED}" -eq 0 ] && echo "INFO: Generated ${GENERATED} private file(s) for $(jq 'length' "${WORK_DIR}/results.json") App(s)"

# Render each Helm or Kustomize App through its own deploy-k8s.sh in the copy, for the cluster's Kubernetes version.
# Plain-manifest Apps have nothing to render: their files are checked as they are.
KUBE_VERSION=$(sed -n 's/^KUBE_VERSION="\(.*\)"$/\1/p' "${REPO_ROOT}/kubernetes/k8s-install/kubespray/run-upgrade.sh")
if [ -z "${KUBE_VERSION}" ]; then
  echo "ERROR: No KUBE_VERSION found in kubernetes/k8s-install/kubespray/run-upgrade.sh"
  exit 1
fi
# Helm's repositories and chart downloads, and the local charts' dependencies, are kept between runs
CACHE_DIR="${HOME}/.cache/homelab-tests"
mkdir -p "${CACHE_DIR}/helm/cache" "${CACHE_DIR}/helm/config" "${CACHE_DIR}/helm/data" "${CACHE_DIR}/chart-dependencies"
mkdir -p "${WORK_DIR}/repo/.git" "${WORK_DIR}/bin" "${WORK_DIR}/out"
# The wrappers only ask git for the repository root, which the bats tests' git stub answers
cp "${REPO_ROOT}/tests/bats/stubs/git" "${WORK_DIR}/bin/git"
for APP_DIR in "${SELECTED[@]}"; do
  WRAPPER="${WORK_DIR}/repo/${APP_DIR}/deploy-k8s.sh"
  if grep -q 'common-deploy-helm.sh' "${WRAPPER}"; then
    echo "${APP_DIR} --template-output /work/out/${APP_DIR//\//_}.yaml --kube-version ${KUBE_VERSION}"
  elif grep -q 'common-deploy-kustomize.sh' "${WRAPPER}"; then
    echo "${APP_DIR} --template-output /work/out/${APP_DIR//\//_}.yaml"
  fi
  # A local chart gets the dependencies of earlier runs, so it only downloads a new version
  if [ -f "${WORK_DIR}/repo/${APP_DIR}/chart/Chart.yaml" ]; then
    mkdir -p "${WORK_DIR}/repo/${APP_DIR}/chart/charts"
    while read -r DEPENDENCY; do
      [ -f "${CACHE_DIR}/chart-dependencies/${DEPENDENCY}" ] && cp "${CACHE_DIR}/chart-dependencies/${DEPENDENCY}" "${WORK_DIR}/repo/${APP_DIR}/chart/charts/"
    done < <(yq '.dependencies[] | .name + "-" + .version + ".tgz"' "${WORK_DIR}/repo/${APP_DIR}/chart/Chart.yaml")
  fi
done > "${WORK_DIR}/render.list"
RENDERS=$(wc -l < "${WORK_DIR}/render.list")

# One container renders them all, a few at a time, with the host's own helm, kubectl, kustomize and yq. It uses the
# host's network, as the default bridge only has IPv4, whose connections out of the LAN fail at random (item 148).
docker run --rm --network host --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -e HELM_CACHE_HOME=/cache/helm/cache -e HELM_CONFIG_HOME=/cache/helm/config -e HELM_DATA_HOME=/cache/helm/data \
    -v "${WORK_DIR}:/work" -v "${CACHE_DIR}:/cache" \
    -v "$(command -v helm):/usr/local/bin/helm:ro" -v "$(command -v kubectl):/usr/local/bin/kubectl:ro" \
    -v "$(command -v kustomize):/usr/local/bin/kustomize:ro" -v "$(command -v yq):/usr/local/bin/yq:ro" \
    -v "${WORK_DIR}/bin/git:/usr/local/bin/git:ro" \
    --entrypoint bash "${EE_IMAGE}" -c '
  xargs -r -P 4 -L 1 bash -c '"'"'
    app=$1; shift
    log=/work/out/${app//\//_}.log
    (cd "/work/repo/${app}" && ./deploy-k8s.sh "$@") > "${log}" 2>&1
    echo $? > "${log%.log}.rc"'"'"' _ < /work/render.list'

while read -r APP_DIR _; do
  OUT="${WORK_DIR}/out/${APP_DIR//\//_}"
  if [ "$(cat "${OUT}.rc" 2>/dev/null)" != "0" ]; then
    echo "FAIL ${APP_DIR}: rendering (exit $(cat "${OUT}.rc" 2>/dev/null || echo none)):"
    grep -E 'ERROR|Error|error' "${OUT}.log" | tail -3 | cut -c1-400
    FAILED=1
  elif ! grep -q '^kind:' "${OUT}.yaml" 2>/dev/null; then
    echo "FAIL ${APP_DIR}: rendering produced no Kubernetes object"
    FAILED=1
  fi
  # Keep the local chart's dependencies for the next run
  if [ -d "${WORK_DIR}/repo/${APP_DIR}/chart/charts" ]; then
    find "${WORK_DIR}/repo/${APP_DIR}/chart/charts" -maxdepth 1 -name '*.tgz' -exec cp -t "${CACHE_DIR}/chart-dependencies" {} +
  fi
done < "${WORK_DIR}/render.list"

[ "${FAILED}" -eq 0 ] && echo "INFO: Rendered ${RENDERS} Helm or Kustomize App(s) for Kubernetes ${KUBE_VERSION}"

# kubeconform -strict validates the renders and every App's extra manifests: the built-in objects against the
# schemas of the cluster's Kubernetes version (the non-standalone ones too, which hold CustomResourceDefinition), the
# custom resources against the pinned CRDs-catalog. A kind without a schema is an error. The schemas are cached.
find "${WORK_DIR}/repo" -path '*/extra-manifests/*' -type f -name '*.yaml' | sort > "${WORK_DIR}/manifests.list"
find "${WORK_DIR}/out" -name '*.yaml' | sort >> "${WORK_DIR}/manifests.list"
mkdir -p "${CACHE_DIR}/kubeconform"
sed 's|^'"${WORK_DIR}"'|/work|' "${WORK_DIR}/manifests.list" > "${WORK_DIR}/manifests-container.list"
docker run --rm --network host --user "$(id -u):$(id -g)" \
    -v "${WORK_DIR}:/work" -v "${CACHE_DIR}/kubeconform:/cache" \
    -v "$(command -v kubeconform):/usr/local/bin/kubeconform:ro" \
    --entrypoint bash "${EE_IMAGE}" -c 'xargs -a /work/manifests-container.list kubeconform -strict -summary -output json -n 4 \
      -kubernetes-version "$1" -cache /cache \
      -schema-location default \
      -schema-location "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/{{.NormalizedKubernetesVersion}}/{{.ResourceKind}}{{.KindSuffix}}.json" \
      -schema-location "https://raw.githubusercontent.com/datreeio/CRDs-catalog/$2/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"' \
    _ "${KUBE_VERSION}" "${CRDS_CATALOG_COMMIT}" > "${WORK_DIR}/kubeconform.json" 2> "${WORK_DIR}/kubeconform.log"
if ! jq -e '.summary' "${WORK_DIR}/kubeconform.json" > /dev/null 2>&1; then
  echo "ERROR: kubeconform failed:"
  tail -5 "${WORK_DIR}/kubeconform.log"
  exit 1
fi
while IFS=$'\t' read -r FILE KIND NAME MSG; do
  echo "FAIL ${FILE}: ${KIND} ${NAME}: ${MSG}"
  FAILED=1
done < <(jq -r '.resources[] | select(.status != "statusValid" and .status != "statusEmpty")
    | [(.filename | sub("^/work/repo/"; "") | sub("^/work/out/"; "render of ")), .kind, .name,
       (.msg | sub("^.*json#. - "; "") | .[0:300])] | @tsv' "${WORK_DIR}/kubeconform.json")
[ "${FAILED}" -eq 0 ] && echo "INFO: kubeconform: $(jq -r '.summary | "\(.valid) valid object(s), \(.invalid) invalid, \(.errors) error(s)"' "${WORK_DIR}/kubeconform.json") in $(wc -l < "${WORK_DIR}/manifests.list") file(s)"

# The Kubernetes App rules, minus the deviations accepted in allowlist-k8s.tsv
RULES_FAILED=0
if ! "${RENDER_DIR}/check-k8s-conventions.sh" "${WORK_DIR}" "$(cat "${WORK_DIR}/internal-domain")" > "${WORK_DIR}/violations.tsv"; then
  echo "ERROR: check-k8s-conventions.sh failed"
  exit 1
fi
grep -v '^#' "${RENDER_DIR}/allowlist-k8s.tsv" | cut -f1-3 | sort -u > "${WORK_DIR}/allowed.tsv"
while IFS=$'\t' read -r APP OBJECT RULE DETAIL; do
  if ! grep -qxF "${APP}"$'\t'"${OBJECT}"$'\t'"${RULE}" "${WORK_DIR}/allowed.tsv"; then
    echo "FAIL ${APP} / ${OBJECT}: ${RULE}: ${DETAIL}"
    RULES_FAILED=1
  fi
done < "${WORK_DIR}/violations.tsv"
# An entry that matches no violation any more (fixed, renamed or removed) only hides a future mistake
if [ "${FULL}" -eq 1 ]; then
  cut -f1-3 "${WORK_DIR}/violations.tsv" | sort -u > "${WORK_DIR}/found.tsv"
  while IFS=$'\t' read -r APP OBJECT RULE; do
    if [ -z "${SKIP[${APP}]+set}" ] && ! grep -qxF "${APP}"$'\t'"${OBJECT}"$'\t'"${RULE}" "${WORK_DIR}/found.tsv"; then
      echo "FAIL allowlist-k8s.tsv: ${APP} / ${OBJECT} / ${RULE} matches nothing any more, remove it"
      RULES_FAILED=1
    fi
  done < "${WORK_DIR}/allowed.tsv"
fi
[ "${RULES_FAILED}" -eq 0 ] && echo "INFO: All App(s) follow the Kubernetes App rules ($(wc -l < "${WORK_DIR}/allowed.tsv") accepted deviation(s))"
[ "${RULES_FAILED}" -eq 1 ] && FAILED=1
exit "${FAILED}"
