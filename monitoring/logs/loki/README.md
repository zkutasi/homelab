# Loki

Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

- [Official site](https://grafana.com/oss/loki/)
- [Source repository](https://github.com/grafana/loki)
- [Documentation](https://grafana.com/docs/loki/latest/)
- [Helm Chart](https://github.com/grafana-community/helm-charts/tree/main/charts/loki)
- ~~Image repo~~
- ~~Other sites~~

## The setup

Loki integrated beautifully into Grafana itself and acts as an endpoint to stream logs into from anywhere.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |seaweedfs_admin_accessKey|M|The S3 access key of the SeaweedFS admin user|
    |seaweedfs_admin_secretKey|M|The S3 secret key of the SeaweedFS admin user|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/logs/loki/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
