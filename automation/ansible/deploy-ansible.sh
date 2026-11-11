#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Installs ansible-navigator and ansible-builder with pipx, then builds the Ansible execution environment image. Takes no options."
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

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
fi
EE_DIR="${REPO_ROOT}/automation/ansible/ansible-execution-environment"
EE_CONFIG="${EE_DIR}/execution-environment.yaml"

echo "Installing Ansible navigator..."
sudo apt-get install -y pipx
pipx install ansible-navigator
pipx install ansible-builder

echo "Build the execution environment..."
ansible-builder build -vvv -f "${EE_CONFIG}" --context "${EE_DIR}/context" -t ansible-execution-environment:latest
