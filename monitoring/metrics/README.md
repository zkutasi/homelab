# Metrics

Collecting, storing and alerting on metrics from the hosts, containers and Apps.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [cAdvisor](https://github.com/google/cadvisor) - Resource usage and performance of running containers
- [InfluxDB](https://www.influxdata.com/) - Datastore for metrics, events and real-time analytics
- Prometheus exporters - Exporters bringing hosts and Apps into Prometheus
- [kube-prometheus-stack](https://prometheus.io) - Prometheus, Alertmanager and Grafana on Kubernetes
- [Silence-operator](https://github.com/giantswarm/silence-operator) - Manages Alertmanager silences as custom resources

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
