#!/bin/bash

# renovate: datasource=docker depName=bats/bats
BATS_VERSION="1.14.0"

function usage() {
    echo "Usage: $0 [--lint | --renovate] [<bats file or folder>...]"
    echo ""
    echo "Runs the bats tests in a container (all of tests/bats by default), ansible-lint in the Ansible execution environment,"
    echo "or a check that Renovate still extracts every dependency from tests/renovate/fixtures."
    echo ""
    echo "Options:"
    echo "  --help        Display this help message"
    echo "  --lint        Run ansible-lint on the whole repository inside the execution environment, instead of the tests"
    echo "  --renovate    Run Renovate's extract-only dry run on the fixtures and compare it with tests/renovate/expected.tsv"
}

LINT=0
RENOVATE=0
TARGETS=()
while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    --lint)
      LINT=1
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

if [ $((LINT + RENOVATE)) -gt 0 ] && [ "${#TARGETS[@]}" -gt 0 ]; then
  echo "ERROR: --lint and --renovate take no test files"
  usage
  exit 1
fi
if [ $((LINT + RENOVATE)) -gt 1 ]; then
  echo "ERROR: --lint and --renovate can't be combined"
  usage
  exit 1
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

# Test files are given relative to the caller's folder; inside the container the repository is /code
CONTAINER_TARGETS=()
for TARGET in "${TARGETS[@]}"; do
  if [ ! -e "${TARGET}" ]; then
    echo "ERROR: ${TARGET} not found"
    exit 1
  fi
  CONTAINER_TARGETS+=("/code/$(realpath --relative-to="${REPO_ROOT}" "${TARGET}")")
done
[ "${#CONTAINER_TARGETS[@]}" -eq 0 ] && CONTAINER_TARGETS=(--recursive /code/tests/bats)

# The tested scripts call these static tools; the host's own binaries are mounted, so the tests use the same versions
TOOL_MOUNTS=()
for TOOL in sops age age-keygen yq; do
  TOOL_PATH=$(command -v "${TOOL}")
  [ -n "${TOOL_PATH}" ] && TOOL_MOUNTS+=(-v "$(realpath "${TOOL_PATH}"):/usr/local/bin/${TOOL}:ro")
done

docker run --rm "${TTY[@]}" --user "$(id -u):$(id -g)" -e HOME=/tmp \
  -v "${REPO_ROOT}:/code:ro" "${TOOL_MOUNTS[@]}" \
  "bats/bats:${BATS_VERSION}" "${CONTAINER_TARGETS[@]}"
