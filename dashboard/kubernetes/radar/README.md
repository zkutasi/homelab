# Skyhook Radar

[Skyhook Radar](https://radarhq.io/) - The missing open source Kubernetes UI. Topology, event timeline, and service traffic — plus resource browsing and Helm management.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add skyhook https://skyhook-io.github.io/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo skyhook/radar -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
