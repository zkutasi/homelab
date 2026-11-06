# NUT Exporter

Network UPS Tools Prometheus Exporter

- ~~Official site~~
- [Source repository](https://github.com/DRuggeri/nut_exporter)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/druggeri/nut_exporter)
- ~~Other sites~~

## The setup

## Prerequisites

- A NUT Server is up and running

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_nut_exporter|M|The host port of the NUT exporter metrics endpoint|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

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
