# X509-certificate-exporter

[X509-certificate-exporter](https://github.com/enix/x509-certificate-exporter) - A Prometheus exporter for X.509 certificates, built for Kubernetes first but equally happy as a standalone binary

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

1. The [matching Grafana dashboard](https://github.com/enix/x509-certificate-exporter/blob/main/chart/grafana-dashboards/x509-certificate-exporter.json) will be auto-provisioned. If not, here it is: [13922](https://grafana.com/grafana/dashboards/13922-certificates-expiration-x509-certificate-exporter/)

## Commands

## Notable comments
