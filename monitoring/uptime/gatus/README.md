# Gatus

Automated developer-oriented status page with alerting and incident support

- [Official site](https://gatus.io/)
- [Source repository](https://github.com/TwiN/gatus)
- [Documentation](https://gatus.io/docs)
- [Image repo](https://hub.docker.com/r/twinproduction/gatus)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |gatus_database_password|M||

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/gatus/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
