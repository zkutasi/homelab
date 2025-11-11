# Alloy

[Alloy](https://grafana.com/docs/alloy/latest/) is a unified metrics and logs (plus more) collector agent, highly configurable and versatile.

## The setup

Alloy is deployed everywhere, on the Kubernetes cluster as well as on standalone hosts. It collects logs and forward them to Loki and metrics are forwarded to Prometheus. Then Grafana has access to both.

## Prerequisites

N/A

## Usage

### Install the kubernetes deployment

1. Add the helm repository

    ```bash
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo grafana/alloy -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Install the host agents on docker hosts

```bash
./common-ansible-run-playbook.sh --playbook monitoring/alloy/docker/deploy-alloy.yaml --no-check
```

### Install the host agents on baremetal hosts

```bash
./common-ansible-run-playbook.sh --playbook monitoring/alloy/host/deploy-alloy.yaml --no-check
```

## Commands

## Notable comments
