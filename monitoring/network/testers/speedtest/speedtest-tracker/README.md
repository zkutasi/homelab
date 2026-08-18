# Speedtest-tracker

Speedtest Tracker is a self-hosted application that monitors the performance and uptime of your internet connection.

- [Official site](https://docs.speedtest-tracker.dev/)
- [Source repository](https://github.com/alexjustesen/speedtest-tracker)
- [Documentation](https://docs.speedtest-tracker.dev/)
- [Image repo](https://hub.docker.com/r/linuxserver/speedtest-tracker)
- ~~Other sites~~

## The setup

Deployed onto the Network appliance Host and measures every X minutes the speed and latency of the connection.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |speedtest_tracker_schedule|M|A cron-expression to specify how many times a test should be scheduled|
    |speedtest_tracker_app_key|M|A generated App-Key|
    |speedtest_tracker_app_url|M|The App URL used in notifications and emails|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate an APP_KEY for encryption with the following command

    ```bash
    echo -n 'base64:'; openssl rand -base64 32;
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/testers/speedtest/speedtest-tracker/deploy-speedtest-tracker.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. On the GUI, enable the Prometheus endpoint under `Settings -> Data Integrations`

2. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

3. Load in any of the matching Grafana dashboards

    - [24608](https://grafana.com/grafana/dashboards/24608-speedtest-tracker/)

## Commands

## Notable comments
