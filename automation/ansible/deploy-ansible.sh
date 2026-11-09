#!/bin/bash

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
