# MetalLB

[MetalLB](https://metallb.io/) is a LoadBalancer implementation for Bare-metal, non-cloud Kubernetes clusters.

## The setup

The external access of the services inside the cluster wil be provided on the IP level via MetalLB.

## Prerequisites

- A few IP addresses -> Set them in file `ipaddresspool.yaml`

## Usage

1. Add the helm repository

    ```bash
    helm repo add metallb https://metallb.github.io/metallb
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo metallb/metallb -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
