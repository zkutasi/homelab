#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Applies the homelab config playbook for real, then redeploys Gatus. Takes no options."
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

"$(git rev-parse --show-toplevel)"/common-ansible-run-playbook.sh \
    --playbook "$(git rev-parse --show-toplevel)"/update-homelab-config.yaml \
    --no-check

pushd "$(git rev-parse --show-toplevel)"/monitoring/uptime/gatus/central
./deploy-k8s.sh
popd
