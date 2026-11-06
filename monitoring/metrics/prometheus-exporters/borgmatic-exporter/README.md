# Borgmatic-exporter

Prometheus exporter for Borgmatic seamlessly integrated into official Borgmatic docker image

- ~~Official site~~
- [Source repository](https://github.com/maxim-mityutko/borgmatic-exporter)
- ~~Documentation~~
- [Image repo](https://github.com/maxim-mityutko/borgmatic-exporter/pkgs/container/borgmatic-exporter)
- ~~Other sites~~

## The setup

Placed next to the Borg repos, and providing it with the repo structure only.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |borgmatic_encryption_passphrase|M|The encryption passphrase of the Borg repositories|
    |port_borgmatic_exporter|M|The host port of the Borgmatic exporter metrics endpoint|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/borgmatic-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/borgmatic-exporter/deploy-borgmatic-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [Official](https://github.com/maxim-mityutko/borgmatic-exporter/blob/master/observability/grafana-dashboard.json)

## Commands

## Notable comments
