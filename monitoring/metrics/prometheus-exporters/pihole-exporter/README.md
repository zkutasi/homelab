# Pihole-exporter

A Prometheus exporter for PI-Hole's Raspberry PI ad blocker

- ~~Official site~~
- [Source repository](https://github.com/eko/pihole-exporter)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/ekofr/pihole-exporter)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pihole_apikey|M|The API key (app password) of the Primary Pi-hole instance, generated on its web UI|
    |pihole_secondary_apikey|O|The API key (app password) of the Secondary Pi-hole instance, if there is one|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pihole_hostname|M|The hostname of the Primary Pi-hole instance|
    |pihole_secondary_hostname|O|The hostname of the Secondary Pi-hole instance|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/pihole-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

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
