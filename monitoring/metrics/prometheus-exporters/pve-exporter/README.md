# pve-exporter

[pve-exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) - Exposes information gathered from Proxmox VE cluster for use by the Prometheus monitoring system

## The setup

## Prerequisites

1. Generate a Proxmox VE user with specific readonly roles

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/pve-exporter/configure-pve-exporter-role.yaml --no-check
    ```

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
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/pve-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/pve-exporter/deploy-pve-exporter.yaml --no-check
    ```

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

## Commands

## Notable comments
