# Homelable

[Homelable](https://homelable.net/) - Self-hosted homelab infrastructure visualizer — interactive network diagram with live status monitoring

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |homelable_auth_username|M||
    |homelable_auth_password_hash|M||
    |homelable_secret_key|M||
    |homelable_url|M||

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook xxx --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
