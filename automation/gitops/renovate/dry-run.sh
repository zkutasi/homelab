#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Runs Renovate locally against this repo in full dry-run mode, needs RENOVATE_TOKEN set. Takes no options."
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${RENOVATE_TOKEN}" ] && echo "RENOVATE_TOKEN is not set" && exit 1

RENOVATE_DIR=$(git rev-parse --show-toplevel)/automation/gitops/renovate
# The same image the deployed chart runs, so a dry-run behaves like production
CHART_NAME=$(sed -n 's/^CHART_NAME=//p' "${RENOVATE_DIR}"/renovate-oss/deploy-k8s.sh)
CHART_VERSION=$(sed -n 's/^VERSION=//p' "${RENOVATE_DIR}"/renovate-oss/deploy-k8s.sh)
RENOVATE_IMAGE=$(helm show values "${CHART_NAME}" --version "${CHART_VERSION}" 2>/dev/null \
    | yq '.image.registry + "/" + .image.repository + ":" + .image.tag')
if [[ ! "${RENOVATE_IMAGE}" =~ ^[^/]+/[^:]+:[^/:]+$ ]] || [[ "${RENOVATE_IMAGE}" == *null* ]]; then
  echo "ERROR: Could not read the Renovate image from chart ${CHART_NAME} ${CHART_VERSION}"
  exit 1
fi

docker run --rm \
    --volume "$(git rev-parse --show-toplevel):/repo" \
    --workdir /repo \
    --env LOG_LEVEL=debug \
    --env RENOVATE_TOKEN="${RENOVATE_TOKEN}" \
    --env RENOVATE_GITHUB_COM_TOKEN="${RENOVATE_TOKEN}" \
    "${RENOVATE_IMAGE}" \
    renovate \
    --platform=local \
    --dry-run=full \
    --print-config
