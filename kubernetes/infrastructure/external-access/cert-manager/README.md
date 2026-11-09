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

1. The internal CA must exist in `security/certificates/certs/` (`ca.crt` and `ca.key`). It is normally already there, with `ca.key` decrypted from its SOPS-encrypted copy. Only on a brand new setup generate it once:

    ```bash
    cd "$(git rev-parse --show-toplevel)"/security/certificates/
    ./internal-certs.sh
    ```

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Load the CA (`security/certificates/certs/ca.crt`) into the Browser as trusted CA

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [22184](https://grafana.com/grafana/dashboards/22184-cert-manager2/)
    - [20842](https://grafana.com/grafana/dashboards/20842-cert-manager-kubernetes/)
    - [20340](https://grafana.com/grafana/dashboards/20340-cert-manager/)

## Commands

## Notable comments
