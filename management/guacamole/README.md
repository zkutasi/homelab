# Guacamole

[Guacamole](https://guacamole.apache.org/) is an SSH, RDP & VNC client running in the browser.

## The setup

Deployed into the Kubernetes cluster and measures every X minutes the speed and latency of the connection.

## Prerequisites

- Cloud Native PG Operator installed

## Usage

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://tccr.io/v2/truecharts/guacamole/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

To debug the resulting helm chart and its details:

```bash
helm template oci://tccr.io/truecharts/guacamole --version XXX --values app-values.yaml --values app-values-private.yaml | less
```

## Notable comments
