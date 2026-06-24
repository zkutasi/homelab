# Cert-manager

[Cert Manager](https://cert-manager.io/) is a convenient tool to create, renew and store certificates.

## The setup

Cert-manager will provide the self-signed certificates from a self-signed rootCA as well as later on a LetsEncrypt-based external access system.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Generate the internal self-signed certificate, valid for 30 years

    ```bash
    cd security/certificates/certs/
    ./internal-certs.sh
    ```

2. Load the generated CA also into the Browser as trusted CA

## Commands

## Notable comments
