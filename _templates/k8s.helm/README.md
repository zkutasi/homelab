# <APP_NAME>

[<APP_NAME>](https://example.com) - A short introduction of the app

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add <APP_NAME_LOWERCASE> XXX
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo <APP_NAME_LOWERCASE>/<APP_NAME_LOWERCASE> -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
