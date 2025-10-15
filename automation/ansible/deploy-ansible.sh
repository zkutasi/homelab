#!/bin/bash

echo "Installing Ansible..."
sudo apt-get install ansible ansible-lint sshpass

echo "Installing some Galaxy packages..."
ansible-galaxy role install simoncaron.pve_permissions
ansible-galaxy collection install community.docker --force
