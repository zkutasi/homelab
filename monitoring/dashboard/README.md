# Kubernetes Dashboard

[Kubernetes Dashboard](https://github.com/kubernetes/dashboard) is the default simple dashboard to observe a Kubernetes cluster and its various workloads and manifests.

## The setup

The default shipped dashboard to observer the Kubernetes cluster.

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo kubernetes-dashboard -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
