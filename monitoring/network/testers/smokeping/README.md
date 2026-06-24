# SmokePing

[SmokePing](https://oss.oetiker.ch/smokeping/) is a tool to periodically check ping stats for multiple remote hosts, continuously.

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
    ./common-ansible-run-playbook.sh --playbook monitoring/network/testers/smokeping/deploy-smokeping.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments
