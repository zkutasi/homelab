#!/bin/bash

terraform destroy -target=proxmox_virtual_environment_vm.k8s_controller_vm
terraform destroy -target=proxmox_virtual_environment_vm.k8s_worker_vm
