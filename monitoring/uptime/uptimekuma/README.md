# UptimeKuma

A fancy self-hosted monitoring tool

- Official site: <https://uptime.kuma.pet/>
- Source repository: <https://github.com/louislam/uptime-kuma>
- Documentation: <https://github.com/louislam/uptime-kuma/wiki>
- Image repo: <https://hub.docker.com/r/louislam/uptime-kuma>
- Other sites: NA

AutoKuma - AutoKuma is a utility that automates the creation of Uptime Kuma monitors based on Docker container labels. With AutoKuma, you can eliminate the need for manual monitor creation in the Uptime Kuma UI.

- Official site: <https://autokuma.bigboot.dev/dev/>
- Source repository: <https://github.com/BigBoot/AutoKuma>
- Documentation: <https://autokuma.bigboot.dev/dev/>
- Image repo: NA
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |uptimekuma_username|M|For Autokuma|
    |uptimekuma_password|M|For Autokuma|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/uptimekuma/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
