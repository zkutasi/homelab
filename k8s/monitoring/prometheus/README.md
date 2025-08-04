# Prometheus & Grafana

[Grafana Official Site](https://grafana.com/). The de-facto visualizer layer for logs, metrics and all kinds of dashboards.
[Prometheus Official Site](https://prometheus.io/). A metrics collection server and time-series database to store these metrics and query them.

## The setup

The used helm chart is the `kube-prometheus-stack`, which installs the following components:

- Grafana provides the visuals, querying Prometheus, Loki and anything other required
- Prometheus collects all the metrics
- Alertmanager provides metrics-based alerting
- Kube-state-metrics provides Kubernetes level metrics
- Node exporter provides Host level metrics --- With Alloy, this is no longer required though

Additionally the following tools are used:

- `smartctl_exporter` - Export SMART data from HDDs and SSDs from all of the systems. Installed on all those systems that have such hardware and then Prometheus collects the metrics.
- `Loki` - Aggregate logs from all of the systems, installed on the Kubernetes cluster.
- `Alloy` - Collect logs and metrics from all of the systems. Installed on all external systems as well as in Kubernetes. Then Loki and Prometheus collects the logs and metrics respectively.

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```

2. Check which version you want to install

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
    ./deploy.sh
    ```

## Commands

## Notable comments
