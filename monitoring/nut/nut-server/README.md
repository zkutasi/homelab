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

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

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
