#!/bin/bash

$(git rev-parse --show-toplevel)/common-ansible-run-playbook.sh \
    --playbook ${PWD}/update-homelab-config.yaml \
    --no-check

pushd $(git rev-parse --show-toplevel)/monitoring/uptime/gatus/central
./deploy-k8s.sh
popd
