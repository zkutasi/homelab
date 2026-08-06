# Cloud Native PostgreSQL (CNPG)

[Cloud Native PostgreSQL](https://cloudnative-pg.io/) is a Kubernetes native way to run PSQL instances.

## The setup

A lot of services require some form of Database, 80% of them are fine with PostgreSQL. the 10% of the time a MariaDB is required, there is a wrapper for CNPG for that. The rest requires maybe its own flavor.

This is only the CNPG operator. For each service, that requires a Database, a separate Postgres instance will be created in those sections.

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

## Metrics, Alerts, Notifications

1. The [matching Grafana dashboard](https://github.com/cloudnative-pg/grafana-dashboards/blob/main/charts/cluster/grafana-dashboard.json) will be auto-provisioned.

## Commands

## Notable comments
