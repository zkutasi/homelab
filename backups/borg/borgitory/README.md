# Borgitory

[Borgitory](https://github.com/mlapaglia/Borgitory) - A Web UI for Borg clients mostly: Handle repos, backups, schedules archives. But also allows to import existing repos and monitor them.

## The setup

I only use the repository monitoring capabilities, as Borgmatic handles my daily backups perfectly fine.

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

```bash
./common-ansible-run-playbook.sh --playbook backups/borg/borgitory/deploy-borgitory.yaml --no-check
```

## Commands

## Notable comments
