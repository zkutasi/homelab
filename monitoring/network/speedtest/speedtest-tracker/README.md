# Speedtest-tracker

[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) is a handy tool to monitors the performance and uptime of the internet connection and graph it.

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

### Deploy the app

1. Generate an APP_KEY for encryption with the following command

    ```bash
    echo -n 'base64:'; openssl rand -base64 32;
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/speedtest/speedtest-tracker/deploy-speedtest-tracker.yaml --no-check
    ```

## Commands

## Notable comments
