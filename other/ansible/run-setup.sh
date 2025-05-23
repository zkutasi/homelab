#/usr/bin/env bash
# Distribute scripts
ansible-playbook -v -i inventory/hosts.yaml setup.yml
