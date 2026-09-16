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

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

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
