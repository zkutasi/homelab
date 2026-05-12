# DockPeek

[DockPeek](https://github.com/dockpeek/dockpeek) - A lightweight, self-hosted Docker dashboard for quick access to your containers. Open web interfaces, view logs, monitor ports, and update images — all from one clean, intuitive interface. It automatically detects Traefik labels and works out of the box with zero configuration.

## The setup

## Prerequisites

## Usage

### Deploy the central component

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    workload:
    main:
        podSpec:
        containers:
            main:
            env:
                USERNAME: <USERNAME>
                PASSWORD: <PASSWORD>
                ...
    ```

2. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/dockpeek/central/generate-configuration.yaml --no-check
    ```

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

4. Deploy a docker socket proxy for each remote host, no agents required/possible

## Commands

## Notable comments
