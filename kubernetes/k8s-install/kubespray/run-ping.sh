#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ "${SCRIPT_DIR}" != "$(pwd -P)" ]; then
  echo "ERROR: Run $(basename "$0") from its own folder: ${SCRIPT_DIR}"
  exit 1
fi

if [ ! -f kubespray-repo/ansible.cfg ]; then
  echo "ERROR: No kubespray-repo folder here, clone it first (see README)"
  exit 1
fi

CMD=(ansible --inventory inventory/hosts.yaml -m ping all)
if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  export ANSIBLE_NAVIGATOR_CONFIG="$(git rev-parse --show-toplevel)/.ansible-navigator.yaml"
  CMD=(ansible-navigator exec --set-environment-variable ANSIBLE_CONFIG="${PWD}/kubespray-repo/ansible.cfg" -- "${CMD[@]}")
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible..."
  export ANSIBLE_CONFIG="${PWD}/kubespray-repo/ansible.cfg"
else
  echo "ERROR: neither ansible-navigator nor ansible is available"
  exit 1
fi

echo "Executing command: ${CMD[*]}"
"${CMD[@]}"
