# conntrack-exporter

Prometheus exporter for tracking network connections

- ~~Official site~~
- [Source repository](https://github.com/hiveco/conntrack_exporter)
- [Documentation](https://hub.docker.com/r/hiveco/conntrack_exporter)
- ~~Image repo~~
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

### Deploy on the hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-exporters/conntrack-exporter/deploy-conntrack-exporter.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
