# UptimeKuma

[Uptime Kuma](https://uptime.kuma.pet/) - An easy-to-use self-hosted monitoring tool

[AutoKuma](https://github.com/BigBoot/AutoKuma) - With AutoKuma, you can eliminate the need for manual monitor creation in the Uptime Kuma UI.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    workloads:
      main:
        podSpec:
          containers:
            autokuma:
              env:
                AUTOKUMA__KUMA__USERNAME: ...
                AUTOKUMA__KUMA__PASSWORD: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
