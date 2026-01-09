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
                DOCKER_HOST_1_URL: tcp://<IP>:<PORT>
                DOCKER_HOST_2_URL: tcp://<IP>:<PORT>
                ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. Deploy a docker socket proxy for each remote host, no agents required (possible, actually)

## Commands

## Notable comments
