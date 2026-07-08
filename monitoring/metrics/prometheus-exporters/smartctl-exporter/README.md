# Smartctl-exporter

[Smartctl-exporter](https://github.com/prometheus-community/smartctl_exporter) - Export smartctl statistics to prometheus

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

### Deploy on the Kubernetes cluster

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/smartctl-exporter/k8s/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/smartctl-exporter/k8s/deploy-smartctl-exporter.yaml --no-check
    ```

### Deploy on the Docker hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/smartctl-exporter/docker/deploy-smartctl-exporter.yaml --no-check
    ```

### Deploy on the Dockerless hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/smartctl-exporter/host/deploy-smartctl-exporter.yaml --no-check
    ```

### Post deployment

1. Deploy the Prometheus ScrapeConfigs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
