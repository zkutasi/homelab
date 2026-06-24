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

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |grafana_admin_user|M||
    |grafana_admin_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/prometheus-grafana/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Create an API token for automation
    - Create a Service Account with `Viewer` rights at Home -> Administration -> Users and access -> Service accounts
    - Create a new Token

## Commands

## Notable comments

- Some good dashboards I use:
  - [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
  - [Ceph Cluster](https://grafana.com/grafana/dashboards/2842-ceph-cluster/)
  - [Fail2Ban banned locations](https://grafana.com/grafana/dashboards/19691-fail2ban-banned-locations/)
  - [NUT Exporter](https://grafana.com/grafana/dashboards/19308-prometheus-nut-exporter-for-druggeri/)
  - [Jetstack version checker](https://grafana.com/grafana/dashboards/12833-version-checker/)
- For a very cool CLI-based tool for Grafana, check out [GDG (Grafana Dash-n-Grab)](https://github.com/esnet/gdg)
- For saving Grafana dashboards into the git repo, one can use the `save-grafana-dashboards.yaml` Ansible playbook. It requires `grafana_dashboards` structure in the `all` group vars to be set: each array element has a field `uid` (get it by looking at the dashboard URL) and `save_name` (without the .json extension).
