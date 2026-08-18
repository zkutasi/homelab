# SeaweedFS

[SeaweedFS](https://seaweedfs.com/) - SeaweedFS is a distributed storage system for object storage (S3), file systems, and Iceberg tables, designed to handle billions of files with O(1) disk access and effortless horizontal scaling.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |seaweedfs_admin_accessKey|M||
    |seaweedfs_admin_secretKey|M||
    |seaweedfs_read_accessKey|M||
    |seaweedfs_read_secretKey|M||

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook storage/s3/seaweedfs/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. The [matching Grafana dashboard](https://github.com/seaweedfs/seaweedfs/blob/master/k8s/charts/seaweedfs/dashboards/seaweedfs-grafana-dashboard.json) will be auto-provisioned.

## Commands

## Notable comments
