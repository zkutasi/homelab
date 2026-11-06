# Qbittorrent-exporter

A fast and lightweight prometheus exporter for qBittorrent

- ~~Official site~~
- [Source repository](https://github.com/martabal/qbittorrent-exporter)
- ~~Documentation~~
- [Image repo](https://github.com/martabal/qbittorrent-exporter/pkgs/container/qbittorrent-exporter)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |qbittorrent_username|M|The qBittorrent WebUI username|
    |qbittorrent_password|M|The qBittorrent WebUI password|
    |port_qbittorrent|M|The host port of the qBittorrent web UI and API|
    |port_qbittorrent_exporter|M|The host port of the qBittorrent exporter metrics endpoint|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/qbittorrent-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/qbittorrent-exporter/deploy-qbittorrent-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [23784](https://grafana.com/grafana/dashboards/23784-qbittorrent/)

## Commands

## Notable comments

- Warning: if you run thousands of torrents, even not switching on the high cardinality metrics would generate a LOT of metrics, several per torrent.
