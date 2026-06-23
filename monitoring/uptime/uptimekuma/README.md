# UptimeKuma

[Uptime Kuma](https://uptime.kuma.pet/) - An easy-to-use self-hosted monitoring tool

[AutoKuma](https://github.com/BigBoot/AutoKuma) - With AutoKuma, you can eliminate the need for manual monitor creation in the Uptime Kuma UI.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |uptimekuma_username|M|For Autokuma|
    |uptimekuma_password|M|For Autokuma|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/uptimekuma/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
