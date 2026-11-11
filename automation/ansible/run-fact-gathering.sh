#!/bin/bash

function usage() {
    echo "Usage: $0 <host>"
    echo ""
    echo "Gathers and prints the Ansible facts of one inventory host or group."
}

HOST=

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    -*)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
    *)
      if [ -n "${HOST}" ]; then
        echo "ERROR: only one host can be given"
        usage
        exit 1
      fi
      HOST=$1
      ;;
  esac
  shift
done

if [ -z "${HOST}" ]; then
  echo "ERROR: No host specified"
  usage
  exit 1
fi

CMD=(ansible "${HOST}" --inventory homelab-ansible-inventory/inventory -m setup)
if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  REPO_ROOT=$(git rev-parse --show-toplevel)
  export ANSIBLE_NAVIGATOR_CONFIG="${REPO_ROOT}/.ansible-navigator.yaml"
  CMD=(ansible-navigator exec -- "${CMD[@]}")
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible..."
else
  echo "ERROR: neither ansible-navigator nor ansible is available"
  exit 1
fi

echo "Executing command: ${CMD[*]}"
"${CMD[@]}"
