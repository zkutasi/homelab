# Prometheus & Grafana

[Grafana](https://grafana.com/): The de-facto visualizer layer for logs, metrics and all kinds of dashboards.
[Prometheus](https://prometheus.io/): A metrics collection server and time-series database to store these metrics and query them.

## The setup

The used helm chart is the `kube-prometheus-stack`, which installs the following components:

- Grafana provides the visuals, querying Prometheus, Loki and anything other required
- Prometheus collects all the metrics
- Alertmanager provides metrics-based alerting
- Kube-state-metrics provides Kubernetes level metrics
- Node exporter provides Host level metrics --- With Alloy, this is no longer required though

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo prometheus-community/kube-prometheus-stack -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    grafana:
      adminUser: ...
      adminPassword: ...

    prometheus:
      prometheusSpec:
        additionalScrapeConfigs:
          ...
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- Some good dashboards I use:
  - [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
  - [Ceph Cluster](https://grafana.com/grafana/dashboards/2842-ceph-cluster/)
  - [Fail2Ban banned locations](https://grafana.com/grafana/dashboards/19691-fail2ban-banned-locations/)
  - [NUT Exporter](https://grafana.com/grafana/dashboards/19308-prometheus-nut-exporter-for-druggeri/)
- For a very cool CLI-based tool for Grafana, check out [GDG (Grafana Dash-n-Grab)](https://github.com/esnet/gdg)
