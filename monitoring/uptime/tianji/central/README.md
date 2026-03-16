# Tianji

[Tianji](https://tianji.dev/) - Insight into everything, Website Analytics + Uptime Monitor + Server Status.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add msgbyte https://msgbyte.github.io/charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo msgbyte/tianji -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    postgresql:
      auth:
        password: ...
    env:
      JWT_SECRET: ...
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
