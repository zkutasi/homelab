# Nut-server

A short introduction of the app

- [Official site](https://networkupstools.org/)
- ~~Source repository~~
- [Documentation](https://networkupstools.org/documentation.html)
- ~~Image repo~~
- ~~Other sites~~

## The setup

There shall be one NUT Server per host that has a UPS connected. Synology devices have their built in NUT Server, no need to install another one.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ups|O|If the host has a UPS attached, create this mapping|
    |ups.name|M|The name of the UPS to identify|
    |ups.driver|M|The USB driver to use. Use nut-scanner to discover the value required.|
    |ups.vendorid|M|The UPS Vendor ID. Use nut-scanner to discover the value required.|
    |ups.productid|M|The UPS Product ID. Use nut-scanner to discover the value required.|
    |ups.desc|M|The UPS description|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/nut/nut-server/deploy-nut-server.yaml --no-check
    ```

### Post deployment

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/nut/nut-server/configure-nut-server.yaml --no-check
    ```

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

## Commands

## Notable comments
