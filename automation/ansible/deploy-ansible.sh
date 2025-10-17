#!/bin/bash

echo "Installing Ansible..."
sudo apt-get install ansible ansible-lint sshpass

echo "Installing Ansible navigator..."
sudo apt-get install pipx
pipx install ansible-navigator
pipx install ansible-builder

echo "Build the execution environment..."
ansible-builder build -vvv -f ansible-execution-environment/execution-environment.yaml -t ansible-execution-environment:latest
