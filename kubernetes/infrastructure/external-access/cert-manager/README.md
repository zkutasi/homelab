# Cert-manager

Automatically provision and manage TLS certificates in Kubernetes

- [Official site](https://cert-manager.io/)
- [Source repository](https://github.com/cert-manager/cert-manager)
- [Documentation](https://cert-manager.io/docs/)
- ~~Image repo~~
- ~~Other sites~~

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

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [22184](https://grafana.com/grafana/dashboards/22184-cert-manager2/)
    - [20842](https://grafana.com/grafana/dashboards/20842-cert-manager-kubernetes/)
    - [20340](https://grafana.com/grafana/dashboards/20340-cert-manager/)

## Commands

## Notable comments
