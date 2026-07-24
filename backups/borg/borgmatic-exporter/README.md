# Borgmatic-exporter

[Borgmatic-exporter](https://github.com/maxim-mityutko/borgmatic-exporter/) - Prometheus exporter for Borgmatic seamlessly integrated into official Borgmatic docker image

## The setup

Placed next to the Borg repos, and providing it with the repo structure only.

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
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgmatic-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgmatic-exporter/deploy-borgmatic-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in the [matching Grafana dashboard](https://github.com/maxim-mityutko/borgmatic-exporter/blob/master/observability/grafana-dashboard.json)

## Commands

## Notable comments
