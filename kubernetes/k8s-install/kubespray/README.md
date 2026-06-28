# Kubespray

[Kubespray](https://github.com/kubernetes-sigs/kubespray) is the Ansible way to install a Kubernetes cluster. Highly configurable and has vast extra capabilities to populate the cluster with standard basic tools.

## The setup

Opted for a 3master + 3worker setup, virtualized under Proxmox. This gives me HA to play with too. Initially I wanted to save resources and go with 3 Nodes only sharing master/worker roles, but figured it would make more sense to keep things separate as I would learn more.

## Prerequisites

- A few VMs or Hosts for Nodes
- Ansible installed

## Usage

### Ansible inventory setup

Kubespray requires an inventory to identify what to do with the Nodes, which roles they are intended to be running. The inventory is best to be created from the sample inventory from the git repo (see later).

### Install

1. First clone the kubespray git repo

    `git clone https://github.com/kubernetes-sigs/kubespray.git kubespray-repo`

2. Copy the inventory as it contains all the settings too

    `cp -R kubespray-repo/inventory/sample inventory`

3. Edit the inventory file itself... I used a YAML format instead of INI
   1. Also edit the settings if needed. These are my changes:

    | File | Setting | Comment |
    |------|---------|---------|
    |group_vars/all/all.yml|ntp_enabled: true||
    |group_vars/k8s_cluster/addons.yml|helm_enabled: true||
    |group_vars/k8s_cluster/addons.yml|metrics_server_enabled: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|kube_proxy_strict_arp: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|kube_encrypt_secret_data: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|kubernetes_audit: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|kubeconfig_localhost: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|auto_renew_certificates: true||
    |group_vars/k8s_cluster/k8s-cluster.yml|coredns_external_zones: ...|Set up the private DNS servers for the `home` network domain|
    |group_vars/k8s_cluster/k8s-cluster.yml|nodelocaldns_external_zones: ...|Set up the private DNS servers for the `home` network domain|
    |group_vars/k8s_cluster/k8s-net-calico.yml|typha_enabled: true|For Whisker this is required|
    |group_vars/k8s_cluster/k8s-net-calico.yml|typha_secure: true|For Whisker this is required|
    |group_vars/k8s_cluster/k8s-net-calico.yml|typha_replicas: 1||
    |group_vars/k8s_cluster/k8s-net-calico.yml|calico_node_extra_envs: ...|Enable Flow logs generation towards Goldmane|

4. Run the ping-check to see if the inventory data is correct

    `./run-ping.sh`

5. Run the installer

    `./run-install.sh`

### Upgrade

You upgrade via checking out a new version of Kubespray first. So lets say, you installed via kubespray 2.29.0. Then you check out the N+1 version first (2.30.0), and upgrade, then the next one. Never jump between versions, it is not supported. Also jump only one Kubernetes major version at a time.

1. Check your version you installed with

    `git describe`

2. Checkout the next version

    `git tag`
    `git checkout <VERSION>`

3. Edit `run-upgrade.sh` and add the desired version to upgrade to. Make sure to jump only 1 major version at a time! Check the file `kubernetes/k8s-install/kubespray/kubespray-repo/extra_playbooks/roles/kubespray_defaults/vars/main/checksums.yml` for the supported versions.

4. Run the upgrade with

    `./run-upgrade.sh`

5. Repeat if necessary

## Commands

- If modifying CoreDNS/NodeLocalDNS, specify the `--extra-args "--tags coredns,nodelocaldns"` also, to execute only the needed updates in the install script
- If modifying Calico settings, specify the `--extra-args "--tags download,calico"` also, to execute only the needed updates in the install script

## Notable comments

- Unfortunately Kubespray is very conservative with Ansible versions... a too new one is just as bad as an old one. Make sure that you have the exact same version. A Navigator build is best to handle this, pinning the Ansible-core version.
- Make sure to also jump only 1 major version of Kubernetes at once, to avoid a failed upgrade.
- Make sure there is no PodDisruptionBudget blocking the Node draining, otherwise it won't get done.
