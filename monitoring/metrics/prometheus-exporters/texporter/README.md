# Texporter

[Texporter](https://github.com/kasd/texporter) - A lightweight, high-performance eBPF-based network traffic exporter for Prometheus.

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
    |texporter_interface|O|The interface to listen on. If not defined, that host will not have texporter installed.|

### Deploy on the hosts

1. Configure from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/texporter/host/configure-texporter.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/texporter/host/deploy-texporter.yaml --no-check
    ```

### Post deployment

1. Deploy the Prometheus ScrapeConfigs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in the [matching Grafana dashboard](https://grafana.com/grafana/dashboards/22901-traffic-monitoring/)

## Commands

## Notable comments

- A tad bit limited: for a given byte, it stores the source and destination IP. There is a possibility to enrich the IPs via reverse DNS lookup also
- The reverse DNS lookup was abismally slow, even the metrics endpoint was not responding for long seconds.
