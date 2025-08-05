# Loki

[Official Site](https://grafana.com/oss/loki/). A log aggregator from Grafana Labs.

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

2. Check which version you want to install

    ```bash
    helm search repo grafana/loki -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy.sh
    ```

## Commands

## Notable comments
