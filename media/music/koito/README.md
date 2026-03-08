# Koito

[Koito](https://example.com) - A short introduction of the app

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |koito_postgres_password|M|The postgres password for Koito|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/koito/deploy-koito.yaml --no-check
```

## Commands

## Notable comments
