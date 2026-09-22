# Pricebuddy

A self hostable app that tracks prices and sends you notifications when prices match your preferences

- [Official site](https://pricebuddy.jez.me/)
- [Source repository](https://github.com/jez500/pricebuddy)
- [Documentation](https://pricebuddy.jez.me/installation.html)
- Image repo:
  - [Pricebudy](https://hub.docker.com/r/jez500/pricebuddy)
  - [Scraper](https://hub.docker.com/r/jez500/seleniumbase-scrapper)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pricebuddy_app_key|M|A unique app-key, generate it with for example `openssl rand -hex 16`|
    |pricebuddy_database_password|M|The database password|
    |pricebuddy_database_rootpassword|M|The database rootpassword|
    |pricebuddy_user_email|M|The app username|
    |pricebuddy_user_password|M|The app password|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook change-tracking/pricebuddy/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
