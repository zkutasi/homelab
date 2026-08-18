# Helm-exporter

[Helm-exporter](https://github.com/sstarcher/helm-exporter) - Export helm stats into the Prometheus format

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

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. The [matching Grafana dashboard](https://github.com/sstarcher/helm-exporter/blob/master/helm/templates/grafana-dashboard.yaml) will be auto-provisioned

## Commands

## Notable comments

- It is vital to enable `intervalDuration` as otherwise the computation is made synchronously, which can easily take longer than the default timeout in Prometheus.
- `latestChartVersion` is disabled, because it just takes too long to configure and there are better ways to do this (with Renovate for example)
- The cool thing is the additional PrometheusRules, without it the exporter has little value.
