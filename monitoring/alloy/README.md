# Alloy

[Alloy](https://grafana.com/docs/alloy/latest/) is a unified metrics and logs (plus more) collector agent, highly configurable and versatile.

## The setup

Alloy is deployed everywhere, on the Kubernetes cluster as well as on standalone hosts. It collects logs and forward them to Loki and metrics are forwarded to Prometheus. Then Grafana has access to both.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the kubernetes deployment

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the host agents on docker hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/alloy/docker/deploy-alloy.yaml --no-check
    ```

### Deploy the host agents on baremetal hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/alloy/host/deploy-alloy.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments
