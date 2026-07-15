#!/bin/bash

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
fi
ANSIBLE_CONFIG="${REPO_ROOT}/ansible.cfg"
ANSIBLE_NAVIGATOR_CONFIG="${REPO_ROOT}/.ansible-navigator.yaml"
INVENTORY="${REPO_ROOT}/automation/ansible/homelab-ansible-inventory/inventory"

CHECK=1
DIFF=1
EXTRA_ARGS=""
LIMIT=
PLAYBOOK=

function usage() {
    echo "Usage: $0 --playbook <playbook> [--inventory <inventory>] [limit <limit>] [--no-diff] [--no-check] [--extra-args <args>]"
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

while [ $# -ge 1 ]; do
  case "$1" in
    --ansible-navigator-config)
      shift
      ANSIBLE_NAVIGATOR_CONFIG="$1"
      ;;
    --extra-args)
      shift
      EXTRA_ARGS="$EXTRA_ARGS $1"
      ;;
    --help)
      usage
      exit 0
      ;;
    --inventory)
      shift
      INVENTORY=$1
      ;;
    --limit)
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
  stdout_callback=$(grep stdout_callback ${ANSIBLE_CONFIG} | awk -F= '{print $2}' | tr -d ' ')
  if [ -n "${stdout_callback}" ]; then
    echo "Setting ANSIBLE_STDOUT_CALLBACK=${stdout_callback}..."
    export ANSIBLE_STDOUT_CALLBACK="${stdout_callback}"
  fi
  CMD="ansible-navigator run ${PLAYBOOK} -m stdout --inventory ${INVENTORY} ${EXTRA_ARGS}"
elif command -v ansible >/dev/null 2>&1; then
  echo "Using ansible-playbook..."
  CMD="ansible-playbook --inventory ${INVENTORY} ${PLAYBOOK} ${EXTRA_ARGS}"
else
  echo "ERROR: neither ansible-navigator nor ansible-playbook is available"
  exit 1
fi

[ "${CHECK}" -eq 1 ] && CMD="${CMD} --check"
[ "${DIFF}" -eq 1 ] && CMD="${CMD} --diff"
[ -n "${LIMIT}" ] && CMD="${CMD} --limit ${LIMIT}"

# CMD="ansible-navigator exec -- ansible-config dump --only-change"
echo "Executing command: ${CMD}"
${CMD}
