# OliveTin

OliveTin gives safe and simple access to predefined shell commands from a web interface.

- Official site: <https://olivetin.app/>
- Source repository: <https://github.com/OliveTin/OliveTin>
- Documentation: <https://docs.olivetin.app/>
- Image repo: <https://hub.docker.com/r/jamesread/olivetin>
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook automation/olivetin/deploy-olivetin.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
