# Pkg-exporter

[Pkg-exporter](https://github.com/margau/pkg-exporter) - This project provides an textfile-based exporter for apt-repositories.

## The setup

The setup was based on [this blogpost](https://margau.net/posts/2021-06-26-prometheus-pkg-exporter/) about the solution.

## Prerequisites

1. Requires pipx 1.7.0+, so install a pipx managed pipx via `setup-python.yaml`

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |node_exporter_textfiles_dir|M|The directory where node-exporter read the texfiles from|

### Deploy the app

1. Configure with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/updates/pkg-exporter/configure-pkg-exporter.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/updates/pkg-exporter/deploy-pkg-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
