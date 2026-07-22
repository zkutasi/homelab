# Pulse

[Pulse](https://github.com/rcourtman/Pulse) - A dashboard for Proxmox servers and docker hosts, with an agent-driven approach.

## The setup

Deploy the central component in the Kubernetes cluster and put down agents everywhere. Agents are single binaries.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central component

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment of the central component

1. In the logs you will find the bootstrap token, use that when going to the UI to set up.
2. Set your Network range in the settings to speed up auto discovery.

### Deploy the unified agents

Agents are deployable from the UI, as it provides a very comprehensive step-by-step tutorial with many alternatives.

### Post deployment

## Commands

## Notable comments

- For temperature monitoring, one needs to install `lm-sensors` package and set it up. V5 and onwards does not need the `sensor-proxy` component anymore.
- For the Admin password, it would not let me through until it was strong enough... be sure to use lower and uppercase characters as well as numbers and at least a special character too.
- The `--insecure` option might be needed to avoid certificate validation issues while installing the Agents. Also use the `-k` switch for the CURL command to avoid this.
- For some reason, I get 100% CPU on both on my cluster (Pulse using like 5-6 CPU) and in my Browser when adding a bunch of Agents. Actually debugging the issue seems to be very hard on itself.
