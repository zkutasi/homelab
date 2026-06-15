#!/bin/bash

docker run --rm -it \
    --volume "$(git rev-parse --show-toplevel):/repo" \
    --workdir /repo \
    --env LOG_LEVEL=debug \
    renovate/renovate:43.220 \
    renovate \
    --platform=local \
    --dry-run=full \
    --print-config
