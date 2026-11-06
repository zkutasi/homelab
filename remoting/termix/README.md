# Termix

Self-hosted SSH and remote desktop management.

- [Official site](https://termix.site/)
- [Source repository](https://github.com/Termix-SSH/Termix)
- [Documentation](https://docs.termix.site/)
- [Image repo](https://github.com/users/lukegus/packages/container/package/termix)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_termix|M|The host port of the Termix web UI|
    |port_termix_guacd|M|The host port of the bundled Guacamole daemon (guacd)|
    |termix_rdp|O|If Guacd is required as well to support RDP. Default is False|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook remoting/termix/deploy-termix.yaml --no-check
    ```

### Post deployment

1. Generate an importable hosts file from the Ansible inventory: every Linux host gets an SSH connection, sorted into docker, proxmox and kubernetes folders

    ```bash
    ./common-ansible-run-playbook.sh --playbook remoting/termix/generate-hosts-json.yaml --no-check
    ```

2. Import the generated `remoting/termix/termix_hosts.json` on the Termix UI

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- With fail2ban's SSH jail, if it is set to `mode=aggressive`, the connectivity check trips the ban. Either turn off the connectivity check on hosts you use fail2ban with this mode, or turn back to the normal mode.
