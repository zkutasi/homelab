# Loki

[Loki](https://grafana.com/oss/loki/) is the log aggregator from Grafana Labs.

## The setup

Loki integrated beautifully into Grafana itself and acts as an endpoint to stream logs into from anywhere.

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo grafana/loki -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
