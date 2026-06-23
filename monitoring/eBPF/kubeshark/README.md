# Kubeshark

[Kubeshark](https://kubeshark.com/) - eBPF-powered network observability for Kubernetes. Indexes L4/L7 traffic with full K8s context, decrypts TLS without keys. Queryable by AI agents via MCP and humans via dashboard.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add kubeshark https://helm.kubeshark.com
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo kubeshark/kubeshark -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
