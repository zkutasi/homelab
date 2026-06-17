#!/bin/bash

[ -z "${RENOVATE_TOKEN}" ] && echo "RENOVATE_TOKEN is not set" && exit 1

RENOVATE_DIR=$(git rev-parse --show-toplevel)/automation/gitops/renovate
RENOVATE_IMAGE_REPO=$(yq '.image.registry' ${RENOVATE_DIR}/renovate-values.yaml)
RENOVATE_IMAGE_TAG=$(yq '.image.tag' ${RENOVATE_DIR}/renovate-values.yaml)

docker run --rm -it \
    --volume "$(git rev-parse --show-toplevel):/repo" \
    --workdir /repo \
    --env LOG_LEVEL=debug \
    --env RENOVATE_TOKEN=${RENOVATE_TOKEN} \
    --env RENOVATE_GITHUB_COM_TOKEN=${RENOVATE_TOKEN} \
    ${RENOVATE_IMAGE_REPO}:${RENOVATE_IMAGE_TAG} \
    renovate \
    --platform=local \
    --dry-run=full \
    --print-config
