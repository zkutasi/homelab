# NetAlertX

Centralized network visibility and continuous asset discovery. Monitor devices, detect change, and stay aware across distributed networks.

- [Official site](https://netalertx.com/)
- [Source repository](https://github.com/netalertx/NetAlertX)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/jokobsk/netalertx)
- ~~Other sites~~

## The setup

I deployed it besides a PiHole to integrate it with.

## Prerequisites

1. PiHole present next to the deployment

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |netalertx_api_token|M|API token for interacting with the service from other Apps|
    |netalertx_interface|M|The interface to scan for devices from.|
    |netalertx_subnet|M|The subnet to scan for devices.|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/netalertx/deploy-netalertx.yaml --no-check
    ```

### Post deployment

1. Go to the UI, and in `Settings -> Core`, note your API token, and place it into `netalertx_api_token`.
2. Go to the UI and mark all known Devices as "not New"

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [Official](https://docs.netalertx.com/samples/API/Grafana_Dashboard.json)

## Commands

## Notable comments
