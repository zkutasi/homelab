# Nexterm

Server Management Software to connect remotely via SSH, VNC and RDP, deploy docker apps, manage Proxmox LXC and QEMU containers.

- Official site: <https://nexterm.dev/>
- Source repository: <https://github.com/gnmyt/Nexterm>
- Documentation: <https://docs.nexterm.dev/>
- Image repo: <https://hub.docker.com/r/germannewsmaker/nexterm>
- Other sites: NA

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

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook remoting/nextterm/deploy-nexterm.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
