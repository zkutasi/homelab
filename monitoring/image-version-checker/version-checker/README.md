# Version-checker

[Jetstack Version-checker](https://github.com/jetstack/version-checker) is a metrics-exposing service to check for image versions.

## The setup

N/A

## Prerequisites

N/A

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo jetstack/version-checker -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
