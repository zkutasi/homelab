# CheckCle

[CheckCle](https://checkcle.io/) - CheckCle is a self-hosted, open-source monitoring platform for seamless, real-time full-stack systems, applications, and infrastructure. It provides real-time uptime monitoring, distributed checks, incident tracking, and alerts. All deployable anywhere.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- Very limited HTTP checks, not even able to set the accepted status codes
- Not able to use an API yet, so configuration is UI only
