# Nebula-sync

[Nebula-sync](https://github.com/lovelaze/nebula-sync) - Synchronize configuration of multiple Pi-hole v6.x instances.

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

```bash
./common-ansible-run-playbook.sh --playbook networking/adblocking/nebula-sync/deploy-nebula-sync.yaml --no-check
```

## Commands

## Notable comments
