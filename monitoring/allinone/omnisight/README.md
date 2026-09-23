# Omnisight

It is a monitoring platform that allows you to monitor multiple platforms on a single page.

- [Official site](https://demo-omnisight.caglaryalcin.com)
- [Source repository](https://github.com/caglaryalcin/OmniSight)
- ~~Documentation~~
- [Image repo](https://github.com/caglaryalcin/omnisight/pkgs/container/omnisight)
- ~~Other sites~~

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

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/allinone/omnisight/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the unified agents

Agents are deployable from the UI, as it provides a very comprehensive step-by-step tutorial with many alternatives.

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

## Commands

## Notable comments

- Does not seem to support docker-compose based Agent deployment.
- Has all kinds of API integrations for example into NAS ecosystems, Dockhand, Portainer, Uptime Kuma, Databases, even Kubernetes. Maybe tries to do too much.
