# Alloy

Grafana Alloy combines the strengths of the leading collectors into one place. Whether observing applications, infrastructure, or both, Grafana Alloy can collect, process, and export telemetry signals to scale and future-proof your observability approach.

- [Official site](https://grafana.com/oss/alloy-opentelemetry-collector/)
- [Source repository](https://github.com/grafana/alloy)
- [Documentation](https://grafana.com/docs/alloy/latest/)
- Image repo:
  - [Docker image](https://hub.docker.com/r/grafana/alloy)
  - [Helm chart](https://github.com/grafana/alloy/tree/main/operations/helm/charts/alloy)
- ~~Other sites~~

## The setup

Alloy is deployed everywhere, on the Kubernetes cluster as well as on standalone hosts. It collects logs and forward them to Loki and metrics are forwarded to Prometheus. Then Grafana has access to both.

Also Alloy bundles Beyla, for no-code instrumentation eBPF application observability.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |alloy_beyla_enabled|O|Whether to enable Beyla's eBPF collector. Default is False|
    |alloy_beyla_geoip_enabled|O|Whether to enable Beyla's GeoIP features. Default is False|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |alloy_monitor_containers|O|Whether to monitor docker containers or not. Default is True|

### Deploy the kubernetes deployment

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the host agents on docker hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/alloy/docker/deploy-alloy.yaml --no-check
    ```

### Deploy the host agents on baremetal hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/alloy/host/deploy-alloy.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Beyla in Alloy seems to be lacking some features, and is generally not on par to the separate Beyla instance, but requires much less configuration (albeit the config is Alloy-esque). It could provide a little better footprint and more unified pipelines.
