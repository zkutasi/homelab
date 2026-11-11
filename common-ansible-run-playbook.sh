#!/bin/bash

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
fi
# An ansible.cfg in the current folder wins, the same way ansible-navigator picks it (e.g. kubespray-repo)
[ -f ./ansible.cfg ] || export ANSIBLE_CONFIG="${REPO_ROOT}/ansible.cfg"
ANSIBLE_NAVIGATOR_CONFIG="${REPO_ROOT}/.ansible-navigator.yaml"
INVENTORY="${REPO_ROOT}/automation/ansible/homelab-ansible-inventory/inventory"

CHECK=1
DIFF=1
EXTRA_ARGS=""
LIMIT=
PLAYBOOK=

function usage() {
    echo "Usage: $0 --playbook <playbook> [--inventory <inventory>] [--limit <limit>] [--no-diff] [--no-check] [--extra-args <args>]"
    echo ""
    echo "Options:"
    echo "  --ansible-navigator-config <config>   Specify the ansible-navigator configuration file"
    echo "  --extra-args <args>                   Specify additional arguments for the Ansible command"
    echo "  --help                                Display this help message"
    echo "  --inventory <inventory>               Specify the Ansible inventory to use"
    echo "  --limit <limit>                       Limit execution to the specified hosts or groups"
    echo "  --no-diff                             Disable diff mode"
    echo "  --no-check                            Disable check mode"
    echo "  --playbook <playbook>                 Specify the Ansible playbook to run (required)"
}

function require_value() {
  if [ -z "$2" ] || [[ "$2" == --* ]]; then
    echo "ERROR: $1 needs a value"
    usage
    exit 1
  fi
}

while [ $# -ge 1 ]; do
  case "$1" in
    --ansible-navigator-config)
      require_value "$1" "$2"
      shift
      ANSIBLE_NAVIGATOR_CONFIG="$1"
      ;;
    --extra-args)
      if [ $# -lt 2 ]; then
        echo "ERROR: --extra-args needs a value"
        usage
        exit 1
      fi
      shift
      EXTRA_ARGS="$EXTRA_ARGS $1"
      ;;
    --help)
      usage
      exit 0
      ;;
    --inventory)
      require_value "$1" "$2"
      shift
      INVENTORY=$1
      ;;
    --limit)
      require_value "$1" "$2"
      shift
      LIMIT=$1
      ;;
    --no-check)
      CHECK=0
      ;;
    --no-diff)
      DIFF=0
      ;;
    --playbook)
      require_value "$1" "$2"
      shift
      PLAYBOOK=$1
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

[ -z "${PLAYBOOK}" ] && echo "ERROR: No playbook specified" && exit 1

if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  export ANSIBLE_NAVIGATOR_CONFIG
  echo "ANSIBLE_NAVIGATOR_CONFIG=${ANSIBLE_NAVIGATOR_CONFIG}"
  CMD=(ansible-navigator run "${PLAYBOOK}" -m stdout --inventory "${INVENTORY}" ${EXTRA_ARGS})
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible-playbook..."
  CMD=(ansible-playbook --inventory "${INVENTORY}" "${PLAYBOOK}" ${EXTRA_ARGS})
else
  echo "ERROR: neither ansible-navigator nor ansible-playbook is available"
  exit 1
fi

[ "${CHECK}" -eq 1 ] && CMD+=(--check)
[ "${DIFF}" -eq 1 ] && CMD+=(--diff)
[ -n "${LIMIT}" ] && CMD+=(--limit "${LIMIT}")

# CMD="ansible-navigator exec -- ansible-config dump --only-change"
echo "Executing command: ${CMD[*]}"
"${CMD[@]}"
