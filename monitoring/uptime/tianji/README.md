# Tianji

[Tianji](https://tianji.dev/) - Insight into everything, Website Analytics + Uptime Monitor + Server Status.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add msgbyte https://msgbyte.github.io/charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo msgbyte/tianji -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    postgresql:
      auth:
        password: ...
    env:
      JWT_SECRET: ...
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- This is a weird project. 70% of the app has something to do with websites, JavaScript injection of telemetry and the actual Uptime monitoring is quite simple looking. THe configuration though is excessive, with HTTP checks for body too... but the UI is very confusing to say the least, and full of grammatical errors.
- The documentation is just all over the place. For me this project wants to be many things, cover a lot of bases, but falls short by not provising enough context or examples. Or this project is tailored to a very specific niche more geared towards a website-owner.
