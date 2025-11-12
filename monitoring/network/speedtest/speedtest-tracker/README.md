# Speedtest-tracker

[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) is a handy tool to monitors the performance and uptime of the internet connection and graph it.

## The setup

Deployed into the Kubernetes cluster and measures every X minutes the speed and latency of the connection.

## Prerequisites

- Cloud Native PG Operator installed

## Usage

### Deploy the app

1. Generate an APP_KEY for encryption with the following command

    ```bash
    echo -n 'base64:'; openssl rand -base64 32;
    ```

2. Create a `.speedtest.env` file with the following content

    ```env
    APP_KEY=<APP_KEY>
    ```

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

To debug the resulting helm chart and its details:

```bash
helm template oci://tccr.io/truecharts/speedtest-tracker --version XXX --values app-values.yaml --values app-values-private.yaml | less
```

## Notable comments
