# Pulse

Monitoring for Proxmox, Docker, Kubernetes, TrueNAS, and vSphere that watches your infrastructure for you: smart alerts, AI patrols that catch silent failures, and verified fixes

- [Official site](https://pulserelay.pro/)
- [Source repository](https://github.com/rcourtman/Pulse)
- [Documentation](https://github.com/rcourtman/Pulse/blob/main/docs/README.md)
- [Image repo](https://hub.docker.com/r/rcourtman/pulse)
- ~~Other sites~~

## The setup

Deploy the central component in the Kubernetes cluster and put down agents everywhere. Agents are single binaries.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/allinone/pulse/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment of the central component

1. In the logs you will find the bootstrap token, use that when going to the UI to set up.
2. Set your Network range in the settings to speed up auto discovery.

### Deploy the unified agents

Agents are deployable from the UI, as it provides a very comprehensive step-by-step tutorial with many alternatives.

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- For temperature monitoring, one needs to install `lm-sensors` package and set it up. V5 and onwards does not need the `sensor-proxy` component anymore.
- For the Admin password, it would not let me through until it was strong enough... be sure to use lower and uppercase characters as well as numbers and at least a special character too.
- The `--insecure` option might be needed to avoid certificate validation issues while installing the Agents. Also use the `-k` switch for the CURL command to avoid this.
- For some reason, I get 100% CPU on both on my cluster (Pulse using like 5-6 CPU) and in my Browser when adding a bunch of Agents. Actually debugging the issue seems to be very hard on itself.
