# InfluxDB

Scalable datastore for metrics, events, and real-time analytics

- [Official site](https://www.influxdata.com/)
- [Source repository](https://github.com/influxdata/influxdb)
- [Documentation](https://docs.influxdata.com/influxdb/v2/)
- [Helm Chart](https://github.com/influxdata/helm-charts/tree/master/charts/influxdb2)
- ~~Image repo~~
- ~~Other sites~~

## The setup

Run InfluxDB 2.x although 3.x is out there, because of simplicity: 3.x requires PostgreSQL and S3 as well. I do not need 3.x special features. Besides, Proxmox for example still likes 2.x, so it should be more compatible with things out there.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |influxdb_user|M|The username of the admin user to create|
    |influxdb_password|M|The password of the admin user|
    |influxdb_admin_token|M|A randomly generated API token for the admin user|
    |influxdb_hostname|M|The hostname InfluxDB is reachable on|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/influxdb/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. On the GUI create an Organization and in it the required buckets.
    1. For Organization, for example use `home`
    2. For Bucket, create one for `proxmox`

## Metrics, Alerts, Notifications

## Commands

## Notable comments
