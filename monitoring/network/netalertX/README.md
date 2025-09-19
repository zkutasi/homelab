# NetAlertX

[NetAlertX](https://netalertx.com/) is a network presence and alerting framework.

## The setup

I deployed it besides a PiHole to integrate it with.

## Prerequisites

- PiHole present next to the deployment

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |netalertx_interface|M|The interface to scan for devices from.|
    |netalertx_subnet|M|The subnet to scan for devices.|

## Usage

Deploy with:

```bash
./common-run-playbook.sh --playbook monitoring/netalertx/deploy-netalertx.yaml --no-check
```

## Notable comments
