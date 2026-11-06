# PatchMon

Linux Patch Management & Automation Platform

- [Official site](https://patchmon.net/)
- [Source repository](https://github.com/PatchMon/PatchMon)
- [Documentation](https://patchmon.net/docs)
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
    |patchmon_redis_password|M|A randomly generated password for the bundled Redis instance|
    |patchmon_database_password|M|The Postgres database password|
    |patchmon_jwt_secret|M|A randomly generated secret|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/updates/patchmon/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Add the agents from the UI, it is just one copy-paste command per host.

## Metrics, Alerts, Notifications

## Commands

## Notable comments
