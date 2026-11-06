# Kopia-exporter

A Prometheus exporter for Kopia backup repositories.

- ~~Official site~~
- [Source repository](https://github.com/ymettier/kopia_go_exporter)
- ~~Documentation~~
- [Image repo](https://github.com/ymettier/kopia_go_exporter/pkgs/container/kopia_go_exporter)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |kopia_client_password|M|The password on the client side|
    |port_kopia|M|The Kopia Server port any Server will listen on|
    |port_kopia_exporter|M|The host port of the Kopia exporter metrics endpoint|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/kopia-exporter/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/kopia-exporter/deploy-kopia-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
