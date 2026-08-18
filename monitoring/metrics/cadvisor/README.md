# CAdvisor

Analyzes resource usage and performance characteristics of running containers.

- ~~Official site~~
- [Source repository](https://github.com/google/cadvisor)
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

Alloy is a more modern approach, but it requires clients to be able to write into the server (Prometheus, Loki, etc). CAdvisor is able to provide metrics and can be scraped, so it is ideal in situations when the central solution is not reachable from the outside.

I use it on my VPS, where the VPS is not yet able to reach the central monitoring stack.

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

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/metrics/cadvisor/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

  ```bash
  ./common-ansible-run-playbook.sh --playbook monitoring/metrics/cadvisor/deploy-cadvisor.yaml --no-check
  ```

### Post deployment

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
