#!/bin/bash

# renovate: datasource=docker depName=bats/bats
BATS_VERSION="1.14.0"

function usage() {
    echo "Usage: $0 <suite>... [--changed <file>... | --list] [<bats file or folder> | <role>...]"
    echo ""
    echo "Runs the named test suites in containers, in the order given (--all: every suite, fastest first). There is no"
    echo "default: name the suites. Every suite runs even when an earlier one failed; the run fails if any of them did."
    echo ""
    echo "Suites:"
    echo "  --all         All of the suites below: bats, renovate, render, render-k8s, molecule, lint"
    echo "  --bats        The bats tests of the given files or folders, or of all of tests/bats; with --changed, only the"
    echo "                test files that cover the changed files (see the '# covers:' headers), all of them for a harness change"
    echo "  --lint        ansible-lint on the whole repository, inside the execution environment, also with --changed"
    echo "  --molecule    The Molecule scenarios of the given roles, or of all roles that have some, in the execution"
    echo "                environment (tests/molecule/molecule.sh); with --changed, only those of the changed roles"
    echo "  --render      Render the Docker Apps against the fake inventory and check them (tests/render/render.sh);"
    echo "                with --changed, only the Apps the changed files belong to"
    echo "  --render-k8s  Generate, render and validate the Kubernetes Apps against the fake inventory"
    echo "                (tests/render/render-k8s.sh); with --changed, only the Apps the changed files belong to"
    echo "  --renovate    Renovate's extract-only dry run on the fixtures, compared with tests/renovate/expected.tsv; with"
    echo "                --changed, only when renovate.json or tests/renovate/ changed"
    echo ""
    echo "Options:"
    echo "  --changed     The arguments are changed files, relative to the repository root, as the commit hooks pass them,"
    echo "                for every named suite"
    echo "  --help        Display this help message"
    echo "  --keep        Keep what the tests leave for inspection: --molecule its targets (and it stops at the first failed"
    echo "                role), the renders their work folder"
    echo "  --list        Only print what would run (--bats and --molecule only)"
    echo ""
    echo "Test files or roles without --changed need a single suite, as they mean different things per suite."
}

ALL_SUITES=(bats renovate render render-k8s molecule lint)
SUITES=()
CHANGED=0
KEEP=0
LIST=0
TARGETS=()
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --all)
      SUITES+=("${ALL_SUITES[@]}")
      ;;
    --bats|--lint|--molecule|--render|--render-k8s|--renovate)
      SUITES+=("${1#--}")
      ;;
    --changed)
      CHANGED=1
      ;;
    --keep)
      KEEP=1
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
      TARGETS+=("$1")
      ;;
  esac
  shift
done
# Each suite once, at its first mention
mapfile -t SUITES < <(printf '%s\n' "${SUITES[@]}" | awk 'NF && !seen[$0]++')

REPO_ROOT=$(git rev-parse --show-toplevel)
TTY=()
[ -t 1 ] && TTY=(-t)

if [ "${#SUITES[@]}" -eq 0 ]; then
  echo "ERROR: name the suites to run: --bats, --lint, --molecule, --render, --render-k8s, --renovate, or --all"
  usage
  exit 1
fi
if [ "${CHANGED}" -eq 0 ] && [ "${#TARGETS[@]}" -gt 0 ]; then
  if [ "${#SUITES[@]}" -gt 1 ]; then
    echo "ERROR: test files or roles need a single suite"
    usage
    exit 1
  fi
  if [[ " lint renovate render render-k8s " == *" ${SUITES[0]} "* ]]; then
    echo "ERROR: --${SUITES[0]} takes no arguments without --changed"
    usage
    exit 1
  fi
fi
if [ "${LIST}" -eq 1 ] && printf '%s\n' "${SUITES[@]}" | grep -q -v -x -E 'bats|molecule'; then
  echo "ERROR: --list works with --bats and --molecule only"
  usage
  exit 1
fi

# Each suite runs in a subshell, so its exit and its cleanup trap stay its own

function suite_molecule() (
  OPTIONS=()
  [ "${CHANGED}" -eq 1 ] && OPTIONS+=(--changed)
  [ "${LIST}" -eq 1 ] && OPTIONS+=(--list)
  [ "${KEEP}" -eq 1 ] && OPTIONS+=(--keep)
  exec "${REPO_ROOT}/tests/molecule/molecule.sh" "${OPTIONS[@]}" "${TARGETS[@]}"
)

function suite_render() (
  OPTIONS=()
  [ "${KEEP}" -eq 1 ] && OPTIONS+=(--keep)
  if [ "${CHANGED}" -eq 1 ]; then
    exec "${REPO_ROOT}/tests/render/render.sh" "${OPTIONS[@]}" --changed "${TARGETS[@]}"
  fi
  exec "${REPO_ROOT}/tests/render/render.sh" "${OPTIONS[@]}"
)

function suite_render-k8s() (
  OPTIONS=()
  [ "${KEEP}" -eq 1 ] && OPTIONS+=(--keep)
  if [ "${CHANGED}" -eq 1 ]; then
    exec "${REPO_ROOT}/tests/render/render-k8s.sh" "${OPTIONS[@]}" --changed "${TARGETS[@]}"
  fi
  exec "${REPO_ROOT}/tests/render/render-k8s.sh" "${OPTIONS[@]}"
)

function suite_renovate() (
  # With changed files, the check only concerns the rules and their fixtures, like its commit hook
  if [ "${CHANGED}" -eq 1 ] && ! printf '%s\n' "${TARGETS[@]}" | grep -q -E '^(renovate\.json|tests/renovate/)'; then
    echo "INFO: Neither renovate.json nor tests/renovate/ changed, nothing to check"
    exit 0
  fi
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
)

function suite_lint() (
  EE_IMAGE=$(yq '.ansible-navigator.execution-environment.image' "${REPO_ROOT}/.ansible-navigator.yaml")
  exec docker run --rm "${TTY[@]}" --user "$(id -u):$(id -g)" -e HOME=/tmp \
    -v "${REPO_ROOT}:/code" -w /code --entrypoint ansible-lint "${EE_IMAGE}"
)

function suite_bats() (
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
  # changed file (outside the Renovate fixtures) every test file that covers it. When only wrappers changed, wrappers.bats checks
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
        # The Renovate fixtures look like the repository's files but are none of them
        [[ "${FILE}" == tests/renovate/fixtures/* ]] && continue
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
)

if [ "${#SUITES[@]}" -eq 1 ]; then
  "suite_${SUITES[0]}"
  exit $?
fi
FAILED=()
for SUITE in "${SUITES[@]}"; do
  echo "INFO: Running the ${SUITE} suite..."
  "suite_${SUITE}" || FAILED+=("${SUITE}")
done
for SUITE in "${SUITES[@]}"; do
  if [[ " ${FAILED[*]} " == *" ${SUITE} "* ]]; then
    echo "ERROR: ${SUITE} failed"
  else
    echo "INFO: ${SUITE} passed"
  fi
done
[ "${#FAILED[@]}" -eq 0 ]
