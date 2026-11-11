#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Pings all Linux and Windows inventory hosts with Ansible. Takes no options."
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

for group in linux windows; do
  echo "Pinging ${group} hosts..."

  ansible_module="ping"
  if [ "${group}" == "windows" ]; then
    ansible_module="ansible.windows.win_ping"
  fi

  CMD=(ansible --inventory homelab-ansible-inventory/inventory -m "${ansible_module}" --limit "${group}" all)
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

done
