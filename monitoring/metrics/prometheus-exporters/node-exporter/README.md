# Node-exporter

[Node-exporter](https://github.com/prometheus/node_exporter) - Exporter for machine metrics

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
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/node-exporter/k8s/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/node-exporter/k8s/deploy-node-exporter.yaml --no-check
    ```

### Deploy on the Docker hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/node-exporter/docker/deploy-node-exporter.yaml --no-check
    ```

### Deploy on the Dockerless hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/node-exporter/host/deploy-node-exporter.yaml --no-check
    ```

### Post deployment

1. Deploy the Prometheus ScrapeConfigs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in the [matching Grafana dashboard](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)

## Commands

## Notable comments
