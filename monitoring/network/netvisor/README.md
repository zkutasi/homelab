# NetVisor

[NetVisor](https://netvisor.io/) - Scans your network, identifies hosts and services, and generates an interactive visualization showing how everything connects, letting you easily create and maintain network documentation.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |netvisor_postgres_user|M|The postgres DB user|
    |netvisor_postgres_password|M|The postgres DB password|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/netvisor/deploy-netvisor.yaml --no-check
```

## Commands

## Notable comments
