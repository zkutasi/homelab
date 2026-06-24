# Checkmate

[CheckMate](https://checkmate.so/) - An open-source, self-hosted tool designed to track and monitor server hardware, uptime, response times, and incidents in real-time with beautiful visualizations.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |checkmate_jwt_secret|M||
    |checkmate_url|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/checkmate/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments

- Swagger API docs are available at `/api-docs`.
- Infrastructure as code is not possible, but the API is there to automate.
- Bulk import seems possible, though the button is missing from the UI for me.
- No API keys are possible, only username/password auth on the API.
- For each monitor, the settings are not as diverse as the other contenders: only the response JSON can be matched against a regex, but not the status code for example.
