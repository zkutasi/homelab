# VaultWarden

Unofficial Bitwarden compatible server written in Rust, formerly known as bitwarden_rs

- ~~Official site~~
- [Source repository](https://github.com/dani-garcia/vaultwarden)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/vaultwarden/server)
- ~~Other sites~~

## The setup

## Prerequisites

1. A reverse proxy with HTTPS and a domain to serve for VaultWarden

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_vaultwarden|M|The host port of the Vaultwarden web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook security/password-mgmt/vaultwarden/deploy-vaultwarden.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
