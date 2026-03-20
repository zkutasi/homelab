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

- Swagger API docs are available at `/api-docs`.
- Infrastructure as code is not possible, but the API is there to automate.
- Bulk import seems possible, though the button is missing from the UI for me.
- No API keys are possible, only username/password auth on the API.
- For each monitor, the settings are not as diverse as the other contenders: only the response JSON can be matched against a regex, but not the status code for example.
