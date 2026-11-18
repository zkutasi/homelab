#!/bin/bash

# renovate: datasource=docker depName=bats/bats
BATS_VERSION="1.14.0"

function usage() {
    echo "Usage: $0 [--lint | --renovate | --render | --render-k8s] [--changed <file>...] [--list] [<bats file or folder>...]"
    echo ""
    echo "Runs the bats tests in a container (all of tests/bats by default), ansible-lint in the Ansible execution environment,"
    echo "or a check that Renovate still extracts every dependency from tests/renovate/fixtures."
    echo ""
    echo "Options:"
    echo "  --changed     The arguments are changed files (relative to the repository root, as the commit hook passes them):"
    echo "                run only the test files that cover them (see the '# covers:' headers), all of them for a harness change"
    echo "  --help        Display this help message"
    echo "  --list        Only print which test files would run"
    echo "  --lint        Run ansible-lint on the whole repository inside the execution environment, instead of the tests"
    echo "  --render      Render the Docker Apps against the fake inventory and check them (tests/render/render.sh);"
    echo "                with --changed, only the Apps the changed files belong to"
    echo "  --render-k8s  Generate, render and validate the Kubernetes Apps against the fake inventory"
    echo "                (tests/render/render-k8s.sh); with --changed, only the Apps the changed files belong to"
    echo "  --renovate    Run Renovate's extract-only dry run on the fixtures and compare it with tests/renovate/expected.tsv"
}

CHANGED=0
LINT=0
LIST=0
RENDER=0
RENDER_K8S=0
RENOVATE=0
TARGETS=()
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --changed)
      CHANGED=1
      ;;
    --lint)
      LINT=1
      ;;
    --list)
      LIST=1
      ;;
    --render)
      RENDER=1
      ;;
    --render-k8s)
      RENDER_K8S=1
      ;;
    --renovate)
      RENOVATE=1
      ;;
    --*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      TARGETS+=("$1")
      ;;
  esac
  shift
done

REPO_ROOT=$(git rev-parse --show-toplevel)
TTY=()
[ -t 1 ] && TTY=(-t)

if [ $((LINT + RENOVATE + RENDER + RENDER_K8S)) -gt 1 ] || [ $((LINT + RENOVATE + CHANGED)) -gt 1 ]; then
  echo "ERROR: --lint, --renovate, --render and --render-k8s can't be combined, nor --lint and --renovate with --changed"
  usage
  exit 1
fi
if [ $((LINT + RENOVATE)) -gt 0 ] || { [ $((RENDER + RENDER_K8S)) -gt 0 ] && [ "${CHANGED}" -eq 0 ]; }; then
  if [ "${#TARGETS[@]}" -gt 0 ]; then
    echo "ERROR: --lint, --renovate, --render and --render-k8s take no test files (the renders take changed files with --changed)"
    usage
    exit 1
  fi
fi

if [ "${RENDER}" -eq 1 ]; then
  if [ "${CHANGED}" -eq 1 ]; then
    exec "${REPO_ROOT}/tests/render/render.sh" --changed "${TARGETS[@]}"
  fi
  exec "${REPO_ROOT}/tests/render/render.sh"
fi

if [ "${RENDER_K8S}" -eq 1 ]; then
  if [ "${CHANGED}" -eq 1 ]; then
    exec "${REPO_ROOT}/tests/render/render-k8s.sh" --changed "${TARGETS[@]}"
  fi
  exec "${REPO_ROOT}/tests/render/render-k8s.sh"
fi

if [ "${RENOVATE}" -eq 1 ]; then
  # The same image the deployed Renovate chart runs, like automation/gitops/renovate/dry-run.sh
  RENOVATE_DIR="${REPO_ROOT}/automation/gitops/renovate"
  CHART_NAME=$(sed -n 's/^CHART_NAME=//p' "${RENOVATE_DIR}/renovate-oss/deploy-k8s.sh")
  CHART_VERSION=$(sed -n 's/^VERSION=//p' "${RENOVATE_DIR}/renovate-oss/deploy-k8s.sh")
  RENOVATE_IMAGE=$(helm show values "${CHART_NAME}" --version "${CHART_VERSION}" 2>/dev/null \
      | yq '.image.registry + "/" + .image.repository + ":" + .image.tag')
  if [[ ! "${RENOVATE_IMAGE}" =~ ^[^/]+/[^:]+:[^/:]+$ ]] || [[ "${RENOVATE_IMAGE}" == *null* ]]; then
    echo "ERROR: Could not read the Renovate image from chart ${CHART_NAME} ${CHART_VERSION}"
    exit 1
  fi
  # The fixtures become a throwaway git repository with the real renovate.json
  WORK_DIR=$(mktemp -d)
  trap 'rm -rf "${WORK_DIR}"' EXIT
  cp -r "${REPO_ROOT}/tests/renovate/fixtures/." "${WORK_DIR}/"
  cp "${REPO_ROOT}/renovate.json" "${WORK_DIR}/"
  echo "INFO: Extracting the fixtures' dependencies with ${RENOVATE_IMAGE}..."
  if ! docker run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp -e LOG_LEVEL=warn \
      -v "${WORK_DIR}:/repo" -w /repo --entrypoint sh "${RENOVATE_IMAGE}" -c \
      'git init -q && git add -A && git -c user.name=test -c user.email=test@localhost commit -qm fixtures \
       && renovate --platform=local --dry-run=extract --report-type=file --report-path=/repo/report.json'; then
    echo "ERROR: Renovate failed"
    exit 1
  fi
  jq -r '.repositories.local.packageFiles | to_entries[] | .key as $m | .value[] | .packageFile as $f | .deps[]
      | [$m, $f, .depName, (.currentValue // "-"), (.datasource // "-"), (if .currentDigest then "digest" else "-" end)]
      | @tsv' "${WORK_DIR}/report.json" | LC_ALL=C sort > "${WORK_DIR}/actual.tsv"
  if diff -u <(grep -v '^#' "${REPO_ROOT}/tests/renovate/expected.tsv") "${WORK_DIR}/actual.tsv"; then
    echo "INFO: Renovate extracts exactly the expected $(wc -l < "${WORK_DIR}/actual.tsv") dependencies"
    exit 0
  fi
  echo "ERROR: Renovate's extraction differs from tests/renovate/expected.tsv (- expected, + extracted)"
  exit 1
fi

if [ "${LINT}" -eq 1 ]; then
  EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
  exec docker run --rm "${TTY[@]}" --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -v "${REPO_ROOT}:/code" -w /code --entrypoint ansible-lint "${EE_IMAGE}"
fi

# Every test file declares what it covers in "# covers: <pattern>..." header lines: paths relative to the
# repository root, where "*" also matches "/"
declare -A COVERS
for TEST_FILE in "${REPO_ROOT}"/tests/bats/*.bats; do
  COVERS[${TEST_FILE}]=$(sed -n 's/^# covers: //p' "${TEST_FILE}" | tr '\n' ' ')
  # A literal path that no longer exists means its test silently lost what it covers (a rename, a deletion)
  # read -a splits the patterns without expanding them as file globs
  read -r -a PATTERNS <<< "${COVERS[${TEST_FILE}]}"
  for PATTERN in "${PATTERNS[@]}"; do
    [[ "${PATTERN}" == *[*?[]* ]] && continue
    [ -e "${REPO_ROOT}/${PATTERN}" ] || echo "WARNING: ${TEST_FILE#"${REPO_ROOT}"/} covers ${PATTERN}, which doesn't exist"
  done
done

# --changed: pick the test files to run. A harness change runs all of them, a changed test file itself, and a
# changed file outside tests/ every test file that covers it. When only wrappers changed, wrappers.bats checks
# just those (WRAPPERS_ONLY) instead of all of them.
WRAPPERS_ONLY=()
if [ "${CHANGED}" -eq 1 ]; then
  CHANGED_FILES=("${TARGETS[@]}")
  TARGETS=()
  HARNESS_CHANGED=0
  for FILE in "${CHANGED_FILES[@]}"; do
    case "${FILE}" in
      tests/run.sh|tests/bats/helpers.bash|tests/bats/stubs/*)
        HARNESS_CHANGED=1
        ;;
    esac
  done
  for TEST_FILE in "${REPO_ROOT}"/tests/bats/*.bats; do
    TEST_REL=${TEST_FILE#"${REPO_ROOT}"/}
    read -r -a PATTERNS <<< "${COVERS[${TEST_FILE}]}"
    SELF_CHANGED=0
    MATCHED=()
    for FILE in "${CHANGED_FILES[@]}"; do
      [ "${FILE}" = "${TEST_REL}" ] && SELF_CHANGED=1
      # Other files under tests/ (the Renovate fixtures, for example) select no test file
      [[ "${FILE}" == tests/* ]] && continue
      for PATTERN in "${PATTERNS[@]}"; do
        # shellcheck disable=SC2053 # matched as a pattern on purpose
        if [[ "${FILE}" == ${PATTERN} ]]; then
          MATCHED+=("${FILE}")
          break
        fi
      done
    done
    if [ $((HARNESS_CHANGED + SELF_CHANGED)) -gt 0 ] || [ "${#MATCHED[@]}" -gt 0 ]; then
      TARGETS+=("${TEST_FILE}")
      if [ "${TEST_REL}" = tests/bats/wrappers.bats ] && [ $((HARNESS_CHANGED + SELF_CHANGED)) -eq 0 ]; then
        WRAPPERS_ONLY=("${MATCHED[@]}")
      fi
    fi
  done
  if [ "${#TARGETS[@]}" -eq 0 ]; then
    echo "INFO: No test covers the changed files"
    exit 0
  fi
fi

if [ "${LIST}" -eq 1 ]; then
  if [ "${#TARGETS[@]}" -eq 0 ]; then
    TARGETS=("${REPO_ROOT}"/tests/bats/*.bats)
  fi
  for TARGET in "${TARGETS[@]}"; do
    TARGET=$(realpath "${TARGET}")
    echo "${TARGET#"${REPO_ROOT}"/}"
  done
  [ "${#WRAPPERS_ONLY[@]}" -gt 0 ] && echo "INFO: wrappers.bats checks only: ${WRAPPERS_ONLY[*]}"
  exit 0
fi

# Test files are given relative to the caller's folder; inside the container the repository is /code
CONTAINER_TARGETS=()
for TARGET in "${TARGETS[@]}"; do
  if [ ! -e "${TARGET}" ]; then
    echo "ERROR: ${TARGET} not found"
    exit 1
  fi
  # Plain realpath and a prefix strip, as --relative-to is GNU-only
  TARGET=$(realpath "${TARGET}")
  CONTAINER_TARGETS+=("/code/${TARGET#"${REPO_ROOT}"/}")
done
[ "${#CONTAINER_TARGETS[@]}" -eq 0 ] && CONTAINER_TARGETS=(--recursive /code/tests/bats)

# The tested scripts call these static tools; the host's own binaries are mounted, so the tests use the same versions
TOOL_MOUNTS=()
for TOOL in sops age age-keygen yq; do
  TOOL_PATH=$(command -v "${TOOL}")
  [ -n "${TOOL_PATH}" ] && TOOL_MOUNTS+=(-v "$(realpath "${TOOL_PATH}"):/usr/local/bin/${TOOL}:ro")
done

docker run --rm "${TTY[@]}" --user "$(id -u):$(id -g)" -e HOME=/tmp -e WRAPPERS_ONLY="${WRAPPERS_ONLY[*]}" \
  -v "${REPO_ROOT}:/code:ro" "${TOOL_MOUNTS[@]}" \
  "bats/bats:${BATS_VERSION}" "${CONTAINER_TARGETS[@]}"
