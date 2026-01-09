# What's Up Docker (WUD)

[WUD](https://getwud.github.io/wud/) - Keep your containers up-to-date! Able to just notify.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    workload:
        main:
            podSpec:
            containers:
                main:
                env:
                    WUD_WATCHER_XXX_HOST: <IP>
                    WUD_WATCHER_XXX_PORT: <PORT>
                    ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. Deploy a docker socket proxy for each remote host, no agents required/possible

## Commands

## Notable comments
