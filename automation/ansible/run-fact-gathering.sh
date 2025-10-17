#!/bin/bash

if [ $# -lt 1 ]; then echo "Usage: $0 HOST"; exit 1; fi
HOST=$1

CMD="ansible ${HOST} --inventory homelab-ansible-inventory/inventory -m setup"
if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  REPO_ROOT=$(git rev-parse --show-toplevel)
  export ANSIBLE_NAVIGATOR_CONFIG="${REPO_ROOT}/.ansible-navigator.yaml"
  CMD="ansible-navigator exec -- ${CMD}"
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible..."
else
  echo "ERROR: neither ansible-navigator nor ansible is available"
  exit 1
fi

echo "Executing command: ${CMD}"
${CMD}
