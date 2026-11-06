# EZBookkeeping

ezBookkeeping is an open source, powerful, self-hosted personal finance app that is easy to use.

- [Official site](https://ezbookkeeping.mayswind.net/)
- [Source repository](https://github.com/mayswind/ezbookkeeping)
- [Documentation](https://ezbookkeeping.mayswind.net/installation/)
- [Image repo](https://hub.docker.com/r/mayswind/ezbookkeeping)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ezbookkeeping_database_password|M|The Postgres database password|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook finance/ezbookkeeping/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
