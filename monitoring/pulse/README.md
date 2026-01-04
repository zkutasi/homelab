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

6. Set your Network range in the settings to speed up auto discovery.

### Deploy the unified agents

Agents are deployable from the UI, as it provides a very comprehensive step-by-step tutorial with many alternatives.

## Commands

## Notable comments

- For temperature monitoring, one needs to install `lm-sensors` package and set it up. V5 and onwards does not need the `sensor-proxy` component anymore.
- For the Admin password, it would not let me through until it was strong enough... be sure to use lower and uppercase characters as well as numbers and at least a special character too.
- The `--insecure` option might be needed to avoid certificate validation issues while installing the Agents. Also use the `-k` switch for the CURL command to avoid this.
