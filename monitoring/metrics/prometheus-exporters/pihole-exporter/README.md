# Pihole-exporter

[Pihole-exporter](https://github.com/eko/pihole-exporter) - A Prometheus exporter for PI-Hole's Raspberry PI ad blocker

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |pihole_hostname|M|The hostname of the Primary PiHole instance|
    |pihole_secondary_hostname|O|The hostname of the Secondary PiHole instance|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/pihole-exporter/deploy-pihole-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [10176](https://grafana.com/grafana/dashboards/10176-pi-hole-exporter/)

## Commands

## Notable comments
