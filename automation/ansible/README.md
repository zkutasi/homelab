# Ansible

[Ansible](https://docs.ansible.com/) is a vast automation framework written in Python, that is able to provision nearly anything after it has an OS and SSH access and python on the remote hosts. It can install software, configure them, and even deploy dockerized containers and so much more.

## The setup

One Ansible control host can access all remote machines (and even localhost as well), and can automate everything.

All kinds of automations are written, common roles, playbooks, and everything required to set things up.

The Ansible inventory is stored in a private git repository.

## Prerequisites

- A control host is required that has Ansible installed and can access to every other machine.
- An inventory set up (by hand, or stored in a private repository)

### Control windows hosts

For windows control, you need to set up WinRM. Open an Administrator CMD and issue the following:

```bash
winrm quickconfig
```

If it is not yet started, say Yes to the questions and it should get configured right away.

Then check if the Listeners are running:

```bash
winrm enumerate winrm/config/Listener
```

## Usage

### Ansible inventory setup

1. Create an inventory folder
2. In it, create a `hosts.yaml` file, and list your hosts
3. You can and should create groups of these hosts too
   - `backupserver` - The Backup Server that hosts all of the backups of the various hosts
   - `backupclient` - The backup clients, those hosts that required to be backed up (install clients, set the directories, etc)
   - `controlserver` - The server that will act as an Ansible control host, git host and terraform host as well as host for other toolings like kubernetes tools.
   - `dnsserver` - All of the local DNS servers like PiHole
   - `docker` - All hosts that prefer dockerized apps over binaries
   - `external` - Represent machines that are fully external. Requires special handling if networking is required towards other services on other Hosts.
   - `kubernetes` - The kubernetes inventory if anything is required on the hosts that Kubespray cannot do itself (Kubespray has its own inventory elsewhere)
   - `linux` - All Linux hosts, separated from Windows ones
   - `networkmonitoring` - Host that provides Flow analysis, IDS, and various other network monitoring capabilities
   - `proxmox` - All the Proxmox hosts
   - `proxmox-clusters` - The individual clusters, as some operations should not be done on all cluster Nodes
   - `reverseproxy` - A host used to run a reverseproxy in the whole network
   - `smart` - Hosts that require S.M.A.R.T. data to be collected
   - `standalone` - Represents the standalone machines, machines that are neither Virtual Environments nor special machines like Synology NAS-es, those require special handling a lot of times.
   - `synology` - All the Synology NAS-es, which require special care
   - `windows` - All Windows hosts, they require a completely different set of roles
4. For global variables common to all or many hosts (shared by a group for example) can go into `group_vars/all` and `group_vars/XXX.yaml` where XXX is a valid group name
5. The following variables can be set on a host (uniquely or on a group):

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |ansible_connection|O|If you set up the local ansible host as well, set this to local on that inventory host|
    |ansible_host|M|The IP address of the machine|
    |ansible_port|O|If the port of the SSH access is different than 22, set it here. Default is 22|
    |ansible_user|M|The user to enter via SSH onto the corresponding host|
    |ansible_ssh_pass|O|If you have SSH password set, set it here, otherwise set passwordless SSH with SSH keys|
    |ansible_become_pass|O|If you have sudo password set, set it here, otherwise set up passwordless sudo first|
    |bash_path|O|If your host has its bash shell path elsewhere, set it here. Default is /usr/bin/env bash|
    |docker_cli_path|O|If for example on Synology devices, the docker path is not by default on the PATH, set it here, and it will be fixed during execution|
    |docker_with_sudo|O|If docker requires sudo to be executed (On Synology NASes it might be true)|
    |id|M|The string identifier of a corresponding host, used throughout all of the roles. Usually it is the name of the server/client/host|
    |timezone|M|The timezone to be set in all containers and on the host as well|

## Commands

Some helper scripts are placed in the repo to ease the execution of the playbooks.

- `run-ping.sh` - The very first thing to do is to check your inventory setup, whether the IPs work or not
- `run-fact-gathering.sh` - Useful to get all the magic variables and facts Ansible would get automatically.
- `common-ansible-run-playbook.sh` - A wrapper script to execute a playbook. By default it runs with check-mode and diff-mode. Check the usage of it if needed.

## Notable comments
