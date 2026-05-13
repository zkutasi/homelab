# Homelable

[Homelable](https://homelable.net/) - Self-hosted homelab infrastructure visualizer — interactive network diagram with live status monitoring

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
            backend:
              env:
                AUTH_USERNAME: ...
                AUTH_PASSWORD_HASH: ...
                CORS_ORIGINS: ...
                SCANNER_RANGES: ...
                SECRET_KEY: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
