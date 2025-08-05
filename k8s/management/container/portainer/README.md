# Portainer

[Official Site](https://www.portainer.io/). A hugely versatile container manager. Supports many flavors (Docker, Podman, Kubernetes) and many Hosts.

## The setup

The central management server is deployed on the Kubernetes cluster, and it manages/observes the Pods and objects there too. All other Hosts in the system have the Portainer Agent installed and attached to the central management server as remote hosts, observing those too.

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add portainer https://portainer.github.io/k8s/
    helm repo update
    ```

2. Check which version you want to install

    ```bash
    helm search repo portainer/portainer -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy.sh
    ```

## Commands

## Notable comments
