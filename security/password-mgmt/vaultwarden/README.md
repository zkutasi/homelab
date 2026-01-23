# VaultWarden

[VaultWarden](https://github.com/dani-garcia/vaultwarden) - An alternative server implementation of the Bitwarden Client API, written in Rust and compatible with official Bitwarden clients, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.

## The setup

## Prerequisites

- A reverse proxy with HTTPS and a domain to serve for VaultWarden

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
./common-ansible-run-playbook.sh --playbook security/password-mgmt/vaultwarden/deploy-vaultwarden.yaml --no-check
```

## Commands

## Notable comments
