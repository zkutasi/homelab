# Kuvasz

[Kuvasz](https://kuvasz-uptime.dev/) - An open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    auth:
      enabled: true
      adminUser: ...
      adminPassword: ...
      adminApiKey: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- No ICMP or DNS test yet, just HTTP, but that one is highly configurable
