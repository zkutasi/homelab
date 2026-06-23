# Kener

[Kener](https://kener.ing/) - Stunning status pages, batteries included!

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |kener_redis_password|M||
    |kener_secret_key|M||
    |kener_url|M||

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/kener/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
