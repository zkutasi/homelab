# BudgetBoard

A simple app for tracking monthly spending and working towards financial goals.

- Official site: <https://budgetboard.net/>
- Source repository: <https://github.com/teelur/budget-board>
- Documentation: <https://budgetboard.net/docs/quick-start-guide>
- Image repo: NA
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |budgetboard_database_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook finance/budgetboard/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
