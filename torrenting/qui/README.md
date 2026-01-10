# Qui

[Qui](https://getqui.com/) - Supports multiple QBitTorrent instances in one UI

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
./common-ansible-run-playbook.sh --playbook torrenting/qui/deploy-qui.yaml --no-check
```

## Commands

## Notable comments
