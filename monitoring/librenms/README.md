# LibreNMS

[Official Site](https://www.librenms.org/)

## The setup

In this tool, one needs to either add the monitored hosts manually or there is a possibility to discover the hosts using SNMP sweep on a given internal IP network. The tool uses the hosts' SNMP daemon to provide information on various layers of data. 

## Prerequisites

Deploy SNMP on each monitored host.

## Usage

1. Add the helm repository

    ```bash
    helm repo add librenms https://www.librenms.org/helm-charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo librenms -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`
   1. Generate a Laravel App-key with this [Laravel Key Generator](https://generate-random.org/laravel-key-generator).

    ```yaml
    librenms:
        appkey: <LARAVEL_API_KEY>
        configuration: |
            <EXTRA_PHP_CONFIG>
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
