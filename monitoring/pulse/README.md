# Pulse

[Pulse](https://github.com/rcourtman/Pulse) - A dashboard for Proxmox servers and docker hosts, with an agent-driven approach.

## The setup

Deploy the central component in the Kubernetes cluster and put down agents everywhere. Agents are single binaries.

## Prerequisites

## Usage

### Deploy the central component

1. Add the helm repository

    ```bash
    helm repo add pulse https://rcourtman.github.io/Pulse/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo pulse/pulse -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

5. In the logs you will find the bootstrap token, use that when going to the UI to set up.

### Deploy the agents

Agents are deployable from the UI, as it provides a very comprehensive step-by-step tutorial with many alternatives.

## Commands

## Notable comments

- For temperature monitoring, one needs to install `lm-sensors` package and set it up. I was unable to make this work though.
- There are thousand-liner bash scripts to deploy things: HTTPS cert handling is a bit of a hassle, and there are other automation issues in the scripts. The problem seems to be that there is just too many use-cases handled: host install, dockerized install, helm chart, PVE and docker support, etc... and in the end there are possibly hundreds of combinations.
