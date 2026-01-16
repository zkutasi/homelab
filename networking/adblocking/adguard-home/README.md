# Adguard Home

[Adguard Home](https://adguard.com/adguard-home/overview.html) - AdGuard Home is a network-wide software for blocking ads and tracking.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |adguardhome_docker_network_3digit|M|The used docker network between AdguardHome and Unbound. Only give the first 3 digits, the last digit is not needed.|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook networking/adblocking/adguard-home/deploy-adguard-home.yaml --no-check
```

## Commands

## Notable comments
