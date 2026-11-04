# Nut-server

The primary goal of the Network UPS Tools (NUT) project is to provide support for Power Devices, such as Uninterruptible Power Supplies, Power Distribution Units, Automatic Transfer Switches, Power Supply Units and Solar Controllers.

- [Official site](https://networkupstools.org/)
- [Source repository](https://github.com/networkupstools/nut)
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
    |nut_server_monitoring_username|M|The username of the NUT monitoring user (monuser) to create|
    |nut_server_monitoring_password|M|The password of the NUT monitoring user|

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

## Commands

## Notable comments
