# Kubeshark

[Kubeshark](https://www.kubeshark.co/) is the Wireshark for Kubernetes. Capture traffic, filter and analyze. Write custom Agents in a programming language even.

## The setup

N/A

## Prerequisites

N/A

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add kubeshark https://helm.kubeshark.co
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
