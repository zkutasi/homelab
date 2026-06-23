# LibreNMS

[LibreNMS](https://www.librenms.org/) is an SNMP based network discovery and monitoring solution.

## The setup

In this tool, one needs to either add the monitored hosts manually or there is a possibility to discover the hosts using SNMP sweep on a given internal IP network. The tool uses the hosts' SNMP daemon to provide information on various layers of data.

## Prerequisites

Deploy SNMP on each monitored host.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |snmp_auth_pass|M||
    |snmp_priv_pass|M||
    |librenms_appkey|M|Generate a Laravel App-key with this [Laravel Key Generator](https://generate-random.org/laravel-key-generator)|

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add librenms https://www.librenms.org/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo librenms -l
    ```

3. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/librenms/generate-configuration.yaml --no-check
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
