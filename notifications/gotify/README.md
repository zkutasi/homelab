# Gotify

[Gotify](https://gotify.net/) - A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |gotify_default_user_pass|M||

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook notifications/gotify/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. On the App UI, generate Apps for each host, and put the tokens into the inventory for those hosts, as `gotify_token`

## Commands

## Notable comments
