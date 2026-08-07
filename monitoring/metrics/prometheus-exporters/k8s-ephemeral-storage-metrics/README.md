# K8s-ephemeral-storage-metrics

[K8s-ephemeral-storage-metrics](https://github.com/jmcgrath207/k8s-ephemeral-storage-metrics) - Prometheus ephemeral storage metrics exporter

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

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [22302](https://grafana.com/grafana/dashboards/22302-kubernetes-ephemeral-storage/)

## Commands

## Notable comments

- This is until kubelet supports it via [this issue](https://github.com/kubernetes/kubernetes/issues/69507)
