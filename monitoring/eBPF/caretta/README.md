# Caretta

[Caretta](https://github.com/groundcover-com/caretta) - Instant K8s service dependency map, right to your Grafana.

## The setup

## Prerequisites

- Grafana & Prometheus stack

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
    ./common-ansible-run-playbook.sh --playbook monitoring/eBPF/caretta/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Load in the Special Grafana dashboard [from here](https://github.com/groundcover-com/caretta/raw/refs/heads/main/chart/dashboard.json)

## Commands

## Notable comments

- The tool relies on Grafana to show the flows: the built network graph, and the traffic outliers. However this severely limits the capabilities of the tool and the Grafana dashboard setup is very hard to adapt.
