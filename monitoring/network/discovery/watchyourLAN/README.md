# WatchYourLAN

[WatchYourLAN](https://github.com/aceberg/WatchYourLAN) - Lightweight network IP scanner written in Go. With notifications, history, export to Grafana

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
    |watchyourlan_interface|M|The interface to listen on|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/watchyourLAN/deploy-watchyourlan.yaml --no-check
```

## Commands

## Notable comments
