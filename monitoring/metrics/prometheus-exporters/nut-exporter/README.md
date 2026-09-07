# NUT Exporter

[NUT Exporter](https://github.com/DRuggeri/nut_exporter) is a Prometheus compatible NUT metrics exporter.

## The setup

## Prerequisites

- A NUT Server is up and running

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ups|O|If the host has a UPS attached, create this mapping|
    |ups.desc|M|The UPS description|
    |nut_server_monitoring_username|M|The monuser username|
    |nut_server_monitoring_password|M|The monuser password|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/nut-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/nut-exporter/deploy-nut-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [19308](https://grafana.com/grafana/dashboards/19308-prometheus-nut-exporter-for-druggeri/)

## Commands

## Notable comments

- I have chosen `network_mode=host`, because otherwise I would need to give a very specific IP address to the Synology NUT Server as allowed remote hosts.
