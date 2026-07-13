# NUT Exporter

[NUT Exporter](https://github.com/DRuggeri/nut_exporter) is a Prometheus compatible NUT metrics exporter.

## The setup

## Prerequisites

- A NUT Server is up and running

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |nut_server_hostname|M|The NUT Server to scrape info from|
    |nut_server_username|M||
    |nut_server_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/nut/nut-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/nut/nut-exporter/deploy-nut-exporter.yaml --no-check
    ```

### Post deployment

1. Deploy the Prometheus ScrapeConfigs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in the [matching Grafana dashboard](https://grafana.com/grafana/dashboards/19308-prometheus-nut-exporter-for-druggeri/)

## Commands

## Notable comments

- I have chosen `network_mode=host`, because otherwise I would need to give a very specific IP address to the Synology NUT Server as allowed remote hosts.
