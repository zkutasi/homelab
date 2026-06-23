# PatchMon

[PatchMon](https://patchmon.net/) - Linux Patch Management & Automation Platform

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |patchmon_redis_password|M||
    |patchmon_database_password|M||
    |patchmon_jwt_secret|M||

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/updates/patchmon/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. Add the agents from the UI, it is just one copy-paste command per host.

## Commands

## Notable comments
