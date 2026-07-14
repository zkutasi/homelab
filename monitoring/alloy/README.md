# Alloy

[Alloy](https://grafana.com/docs/alloy/latest/) is a unified metrics and logs (plus more) collector agent, highly configurable and versatile.

## The setup

Alloy is deployed everywhere, on the Kubernetes cluster as well as on standalone hosts. It collects logs and forward them to Loki and metrics are forwarded to Prometheus. Then Grafana has access to both.

Also Alloy bundles Beyla, for no-code instrumentation eBPF application observability.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |alloy_beyla_enabled|O|Whether to enable Beyla's eBPF collector. Default is False|
    |alloy_beyla_geoip_enabled|O|Whether to enable Beyla's GeoIP features. Default is False|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
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

## Commands

## Notable comments

- Beyla in Alloy seems to be lacking some features, and is generally not on par to the separate Beyla instance, but requires much less configuration (albeit the config is Alloy-esque). It could provide a little better footprint and more unified pipelines.
