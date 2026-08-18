# ExpenseOwl

Extremely simple, self-hosted expense tracker with a beautiful UI.

- ~~Official site~~
- [Source repository](https://github.com/Tanq16/ExpenseOwl)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/tanq16/expenseowl)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |expenseowl_database_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook finance/expenseowl/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
