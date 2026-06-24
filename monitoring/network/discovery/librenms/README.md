# LibreNMS

[LibreNMS](https://www.librenms.org/) is an SNMP based network discovery and monitoring solution.

## The setup

In this tool, one needs to either add the monitored hosts manually or there is a possibility to discover the hosts using SNMP sweep on a given internal IP network. The tool uses the hosts' SNMP daemon to provide information on various layers of data.

## Prerequisites

1. Deploy SNMP on each monitored host.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |snmp_auth_pass|M||
    |snmp_priv_pass|M||
    |librenms_appkey|M|Generate a Laravel App-key with this [Laravel Key Generator](https://generate-random.org/laravel-key-generator)|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/librenms/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments
