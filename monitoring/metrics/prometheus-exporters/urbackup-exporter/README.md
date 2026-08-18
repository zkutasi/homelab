# Urbackup-exporter

[Urbackup-exporter](https://github.com/ngosang/urbackup-exporter) - Prometheus exporter for the UrBackup backup system

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/urbackup-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/urbackup-exporter/deploy-urbackup-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [Official](https://github.com/ngosang/urbackup-exporter/blob/master/grafana/grafana_dashboard.json)

## Commands

## Notable comments
