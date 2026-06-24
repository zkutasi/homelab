# Jellyfin

[Jellyfin](https://jellyfin.org/) - The Free Software Media System - Server Backend & API

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
    ./common-ansible-run-playbook.sh --playbook media/allinone/jellyfin/deploy-jellyfin.yaml --no-check
    ```

### Post deployment

1. Configure ignored files

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/jellyfin/configure-ignore.yaml --no-check
    ```

## Commands

## Notable comments
