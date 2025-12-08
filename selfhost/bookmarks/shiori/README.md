# Shiori

[Shiori](https://github.com/go-shiori/shiori) - Intended as a simple clone of Pocket.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://tccr.io/v2/truecharts/shiori/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

4. Use the default user/password of `shiori/gopher` to log in first

## Commands

## Notable comments
