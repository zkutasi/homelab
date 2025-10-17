#!/bin/bash

CHECK=1
DIFF=1
LIMIT=
PLAYBOOK=

function usage() {
    echo "Usage: $0 --playbook <playbook> [--limit <limit>] [--no-diff] [--no-check]"
    echo ""
    echo "Options:"
    echo "  --playbook <playbook>   Specify the Ansible playbook to run (required)"
    echo "  --limit <limit>         Limit execution to the specified hosts or groups"
    echo "  --no-diff               Disable diff mode"
    echo "  --no-check              Disable check mode"
}

while [ $# -ge 1 ]; do
  case "$1" in
    --playbook)
      shift
      PLAYBOOK=$1
      ;;
    --limit)
      shift
      LIMIT=$1
      ;;
    --no-diff)
      DIFF=0
      ;;
    --no-check)
      CHECK=0
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

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
fi

INVENTORY="${REPO_ROOT}/automation/ansible/homelab-ansible-inventory/inventory"

if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  CMD=(ansible-navigator run "${PLAYBOOK}" -m stdout --inventory "${INVENTORY}")
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible-playbook..."
  CMD="ansible-playbook --inventory ${INVENTORY} ${PLAYBOOK}"
else
  echo "ERROR: neither ansible-navigator nor ansible-playbook is available"
  exit 1
fi

[ "${CHECK}" -eq 1 ] && CMD="${CMD} --check"
[ "${DIFF}" -eq 1 ] && CMD="${CMD} --diff"
[ -n "${LIMIT}" ] && CMD="${CMD} --limit ${LIMIT}"

echo "Executing command: ${CMD}"
${CMD}
