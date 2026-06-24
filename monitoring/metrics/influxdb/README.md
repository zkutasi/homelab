# InfluxDB

[InfluxDB](https://www.influxdata.com/) is a Time Series database from InfluxData.

## The setup

Run InfluxDB 2.x although 3.x is out there, because of simplicity: 3.x requires PostgreSQL and S3 as well. I do not need 3.x special features. Besides, Proxmox for example still likes 2.x, so it should be more compatible with things out there.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |influxdb_user|M||
    |influxdb_password|M||
    |influxdb_admin_token|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

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

## Commands

## Notable comments
