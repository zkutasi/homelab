# Kener

[Kener](https://kener.ing/) - Stunning status pages, batteries included!

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    redis:
      password: ...

      workload:
        main:
          podSpec:
          containers:
            main:
            env:
              KENER_SECRET_KEY: ...
              ORIGIN: ...
              REDIS_URL: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
