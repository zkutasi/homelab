# Windows-exporter

Prometheus exporter for Windows machines

- ~~Official site~~
- [Source repository](https://github.com/prometheus-community/windows_exporter)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/prometheuscommunity/windows-exporter)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_windows_exporter|M|The port of the Windows exporter metrics endpoint on the Windows hosts|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

Deploy it manually.

### Post deployment

## Metrics, Alerts, Notifications

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/windows-exporter/generate-configuration.yaml --no-check
    ```

2. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
