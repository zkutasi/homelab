# Speedtest-tracker

[Official Site](https://github.com/alexjustesen/speedtest-tracker). Monitors the performance and uptime of the internet connection.

## The setup

Deployed into the Kubernetes cluster and measures every X minutes the speed and latency of the connection.

## Prerequisites

- Cloud Native PG Operator installed

## Usage

1. Check which version you want to install

    ```bash
    curl -s https://tccr.io/v2/truecharts/speedtest-tracker/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy.sh
    ```

## Commands

To debug the resulting helm chart and its details:

```bash
helm template oci://tccr.io/truecharts/speedtest-tracker --version XXX --values app-values.yaml --values app-values-private.yaml | less
```

## Notable comments
