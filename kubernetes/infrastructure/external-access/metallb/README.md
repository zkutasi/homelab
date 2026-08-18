# MetalLB

A network load-balancer implementation for Kubernetes using standard routing protocols

- [Official site](https://metallb.io/)
- [Source repository](https://github.com/metallb/metallb)
- [Documentation](https://metallb.io/)
- [Helm Chart](https://github.com/metallb/metallb/tree/main/charts/metallb)
- ~~Other sites~~

## The setup

The external access of the services inside the cluster will be provided on the IP level via MetalLB.

## Prerequisites

- A few IP addresses -> Set them in file `ipaddresspool.yaml`

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook kubernetes/infrastructure/external-access/metallb/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Some PrometheusAlerts are delivered by the chart itself

2. Load in any of the matching Grafana dashboards

    - [25519](https://grafana.com/grafana/dashboards/25519-metallb-l2-mode/)
    - [20162](https://grafana.com/grafana/dashboards/20162-metallb/)

## Commands

## Notable comments
