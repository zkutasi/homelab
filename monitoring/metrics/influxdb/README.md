# InfluxDB

[InfluxDB](https://www.influxdata.com/) is a Time Series database from InfluxData.

## The setup

Run InfluxDB 2.x although 3.x is out there, because of simplicity: 3.x requires PostgreSQL and S3 as well. I do not need 3.x special features. Besides, Proxmox for example still likes 2.x, so it should be more compatible with things out there.

## Prerequisites

N/A

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add influxdata https://helm.influxdata.com/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo influxdata/influxdb2 -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

5. On the GUI create an Organization and in it the required buckets.
    1. For Organization, for example use `home`
    2. For Bucket, create one for `proxmox`

## Commands

## Notable comments
