terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
    }
  }
}

provider "proxmox" {
  endpoint = var.endpoint
  api_token = var.api_token
  insecure = true
  ssh {
    agent = true
    username = "terraform"
    dynamic "node" {
      for_each = var.pves
      content {
        name = node.value["name"]
        address = node.value["address"]
      }
    }
  }
}

provider "htpasswd" {
}

resource "htpasswd_password" "hash" {
  password = var.password
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  count = length(var.pves)
  content_type = "iso"
  datastore_id = "local"
  node_name = var.pves[count.index]["name"]

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  count = length(var.pves)
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.pves[count.index]["name"]

  source_raw {
    data = <<-EOF
    #cloud-config
    timezone: Europe/Budapest
    users:
      - default
      - name: ${var.username}
        passwd: ${htpasswd_password.hash.sha512}
        lock_passwd: false
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_pwauth: True
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config_controller" {
  count = length(var.pves)
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.pves[count.index]["name"]

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${var.k8s_controllers[count.index]["name"]}
    EOF

    file_name = "meta-data-cloud-config_controller.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config_worker" {
  count = length(var.pves)
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.pves[count.index]["name"]

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${var.k8s_workers[count.index]["name"]}
    EOF

    file_name = "meta-data-cloud-config_worker.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "k8s_controller_vm" {
  count = length(var.k8s_controllers)
  name = var.k8s_controllers[count.index]["name"]
  node_name = var.k8s_controllers[count.index]["node_name"]
  vm_id = var.k8s_controllers[count.index]["vm_id"]

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.k8s_controllers[count.index]["address"]
        gateway = "192.168.31.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[count.index].id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config_controller[count.index].id
  }

  cpu {
    cores = var.k8s_controllers[count.index]["cpu"]
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k8s_controllers[count.index]["memory"]
    floating  = var.k8s_controllers[count.index]["memory"]
  }

  disk {
    datastore_id = "bigdata"
    discard = "on"
    file_id = proxmox_virtual_environment_download_file.ubuntu_cloud_image[count.index].id
    interface = "sata0"
    size = var.k8s_controllers[count.index]["disk"]
    ssd = true
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_vm" "k8s_worker_vm" {
  count = length(var.k8s_workers)
  name = var.k8s_workers[count.index]["name"]
  node_name = var.k8s_workers[count.index]["node_name"]
  vm_id = var.k8s_workers[count.index]["vm_id"]

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.k8s_workers[count.index]["address"]
        gateway = "192.168.31.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[count.index].id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config_worker[count.index].id
  }

  cpu {
    cores = var.k8s_workers[count.index]["cpu"]
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k8s_workers[count.index]["memory"]
    floating  = var.k8s_workers[count.index]["memory"]
  }

  disk {
    datastore_id = "bigdata"
    discard = "on"
    file_id = proxmox_virtual_environment_download_file.ubuntu_cloud_image[count.index].id
    interface = "sata0"
    size = var.k8s_workers[count.index]["disk"]
    ssd = true
  }

  disk {
    datastore_id = "bigdata"
    discard = "on"
    interface = "sata1"
    size = var.k8s_workers[count.index]["disk_data"]
    ssd = true
  }

  network_device {
    bridge = "vmbr0"
  }
}
