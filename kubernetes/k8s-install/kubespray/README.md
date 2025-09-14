# Kubespray

[Kubespray](https://github.com/kubernetes-sigs/kubespray) is the Ansible way to install a Kubernetes cluster. Highly configurable and has vast extra capabilities to populate the cluster with standard basic tools.

## The setup

Opted for a 3master + 3worker setup, virtualized under Proxmox. This gives me HA to play with too. Initially I wanted to save resources and go with 3 Nodes only sharing master/worker roles, but figured it would make more sense to keep things separate as I would learn more.

## Prerequisites

- A few VMs or Hosts for Nodes
- Ansible installed

## Ansible inventory setup

Kubespray requires an inventory to identify what to do with the Nodes, which roles they are intended to be running. The inventory is best to be created from the sample inventory from the git repo (see later).

## Usage

1. First clone the kubespray git repo

    `git clone https://github.com/kubernetes-sigs/kubespray.git kubespray-repo`

2. Copy the inventory as it contains all the settings too

    `cp -R kubespray-repo/inventory/sample inventory`

3. Edit the inventory file itself... I used a YAML format instead of INI
   1. Also edit the settings if needed. These are my changes:

    | File | Setting |
    |------|---------|
    |group_vars/all/all.yml|ntp_enabled: true|
    |group_vars/k8s_cluster/addons.yml|helm_enabled: true|
    |group_vars/k8s_cluster/addons.yml|metrics_server_enabled: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|kube_proxy_strict_arp: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|kube_encrypt_secret_data: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|deploy_netchecker: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|kubernetes_audit: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|kubeconfig_localhost: true|
    |group_vars/k8s_cluster/k8s-cluster.yml|auto_renew_certificates: true|

4. Run the ping-check to see if the inventory data is correct

    `./run-ping.sh`

5. Run the installer

    `./rin-install.sh`

## Commands

## Notable comments
