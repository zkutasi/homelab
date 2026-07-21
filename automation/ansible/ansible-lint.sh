#!/bin/bash

REPO_ROOT="."
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
fi
ANSIBLE_NAVIGATOR_CONFIG="${REPO_ROOT}/.ansible-navigator.yaml"

if command -v ansible-navigator >/dev/null 2>&1; then
  echo "Using ansible-navigator..."
  export ANSIBLE_NAVIGATOR_CONFIG
  echo "ANSIBLE_NAVIGATOR_CONFIG=${ANSIBLE_NAVIGATOR_CONFIG}"
  CMD="ansible-navigator exec -- ansible-lint -v"
else
  echo "Using ansible-lint directly..."
  CMD="ansible-lint -v"
fi

echo "Executing command: ${CMD}"
${CMD}
