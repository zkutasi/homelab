# What's Up Docker (WUD)

Keep your containers up-to-date! Able to just notify.

- Official site: <https://getwud.github.io/wud>
- Source repository: <https://github.com/getwud/wud>
- Documentation: <https://getwud.github.io/wud/#/?id=introduction>
- Image repo: <https://hub.docker.com/r/getwud/wud>
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/wud/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Deploy a docker socket proxy for each remote host, no agents required/possible

## Metrics, Alerts, Notifications

## Commands

## Notable comments
