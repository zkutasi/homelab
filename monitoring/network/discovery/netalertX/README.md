# NetAlertX

[NetAlertX](https://netalertx.com/) is a network presence and alerting framework.

## The setup

I deployed it besides a PiHole to integrate it with.

## Prerequisites

1. PiHole present next to the deployment

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |netalertx_interface|M|The interface to scan for devices from.|
    |netalertx_subnet|M|The subnet to scan for devices.|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/netalertx/deploy-netalertx.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments
