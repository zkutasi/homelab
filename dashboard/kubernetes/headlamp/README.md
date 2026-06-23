# Headlamp

[Headlamp](https://headlamp.dev/) - A Kubernetes web UI that is fully-featured, user-friendly and extensible

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo headlamp/headlamp -l
    ```

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- I had to bypass the authentication as it only supports OIDC and token-based ones. Used [this issue](https://github.com/kubernetes-sigs/headlamp/issues/1801) as inspiration.
