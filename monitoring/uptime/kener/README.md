# Kener

Stunning status pages, batteries included!

- [Official site](https://kener.ing/)
- [Source repository](https://github.com/rajnandan1/kener)
- [Documentation](https://kener.ing/docs)
- ~~Image repo~~
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |kener_redis_password|M|A randomly generated password for the bundled Redis instance|
    |kener_secret_key|M|A randomly generated secret|
    |kener_url|M|The full URL the app is reached on (e.g. `https://kener.example.home`)|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/kener/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
