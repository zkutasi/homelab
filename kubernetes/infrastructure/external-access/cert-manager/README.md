# Cert-manager

[Cert Manager](https://cert-manager.io/) is a convenient tool to create, renew and store certificates.

## The setup

Cert-manager will provide the self-signed certificates from a self-signed rootCA as well as later on a LetsEncrypt-based external access system.

## Prerequisites

N/A

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo jetstack/cert-manager -l
    ```

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

4. Generate the internal self-signed certificate, valid for 30 years

    ```bash
    cd security/certificates/certs/
    ./internal-certs.sh
    ```

5. Load the generated CA also into the Browser as trusted CA

## Commands

## Notable comments
