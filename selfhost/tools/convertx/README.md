# ConvertX

[ConvertX](https://github.com/C4illin/ConvertX) is a useful set of file conversions in one package.

## The setup

Just run the image in a cluster, and access the tools in a browser.

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```env
    secret:
        jwt-secret:
            enabled: true
            data:
            jwt-secret: <A_RANDOM_SECRET_STRING>
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
