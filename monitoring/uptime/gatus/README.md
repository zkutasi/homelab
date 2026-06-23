# Gatus

[Gatus](https://gatus.io/) - Gatus is a developer-oriented health dashboard that gives you the ability to monitor your services using HTTP, ICMP, TCP, and even DNS queries as well as evaluate the result of said queries by using a list of conditions on values like the status code, the response time, the certificate expiration, the body and many others. The icing on top is that each of these health checks can be paired with alerting via Slack, Teams, PagerDuty, Discord, Twilio and many more.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |gatus_database_password|M||

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/gatus/tags/list | jq
    ```

2. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/gatus/central/generate-configuration.yaml --no-check
    ```

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
