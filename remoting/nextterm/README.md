# Nexterm

[NexTerm](https://github.com/gnmyt/Nexterm?ref=noted.lol) - Server Management Software to connect remotely via SSH, VNC and RDP, deploy docker apps, manage Proxmox LXC and QEMU containers.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |nextterm_encryption_key|M|The encryption key used|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook remoting/nextterm/deploy-nexterm.yaml --no-check
```

## Commands

## Notable comments
