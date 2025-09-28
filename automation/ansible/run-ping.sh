#!/bin/bash

ansible --inventory homelab-ansible-inventory/inventory -m ping all
