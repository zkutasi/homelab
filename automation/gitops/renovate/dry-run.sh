#!/bin/bash

[ -z "${RENOVATE_TOKEN}" ] && echo "RENOVATE_TOKEN is not set" && exit 1

docker run --rm -it \
    --volume "$(git rev-parse --show-toplevel):/repo" \
    --workdir /repo \
    --env LOG_LEVEL=debug \
    --env RENOVATE_TOKEN=${RENOVATE_TOKEN}$ \
    --env RENOVATE_GITHUB_COM_TOKEN=${RENOVATE_TOKEN} \
    renovate/renovate:43.220 \
    renovate \
    --platform=local \
    --dry-run=full \
    --print-config
