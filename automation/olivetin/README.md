# OliveTin

OliveTin gives safe and simple access to predefined shell commands from a web interface.

- [Official site](https://olivetin.app/)
- [Source repository](https://github.com/OliveTin/OliveTin)
- [Documentation](https://docs.olivetin.app/)
- [Image repo](https://hub.docker.com/r/jamesread/olivetin)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_olivetin|M|The host port of the OliveTin web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook automation/olivetin/deploy-olivetin.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
