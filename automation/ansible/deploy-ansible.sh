#!/bin/bash

echo "Installing Ansible..."
sudo apt-get install ansible sshpass

echo "Installing some Galaxy packages..."
ansible-galaxy role install simoncaron.pve_permissions
