# Checkmate

[CheckMate](https://checkmate.so/) - An open-source, self-hosted tool designed to track and monitor server hardware, uptime, response times, and incidents in real-time with beautiful visualizations.

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
            CLIENT_HOST: ...
            JWT_SECRET: ...
            UPTIME_APP_API_BASE_URL: ...
            UPTIME_APP_CLIENT_HOST: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
