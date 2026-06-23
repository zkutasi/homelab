# Apprise

[Apprise](https://appriseit.com/) - Push Notifications that work with just about every platform!

## The setup

Use Apprise as a notification router towards the 130+ services it supports.
Wire behind Apprise:

- Ntfy
- Gotify
- Pushover
- Email (potentially)

Try to use Apprise in every other microservice as push-notification endpoint.
If a service does not support Apprise, it might support Ntfy or Gotify or Pushover.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |apprise_api_hostname|M|The Apprise API hostname to configure the notification architecture with|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |gotify_token|O|The app token for Gotify to identify the host in the notifications|
    |pushover_token|O|The app token for Pushover to identify the host in the notifications|

### Deploy the app

1. Generate the configuration and upload it to the API

    ```bash
    ./common-ansible-run-playbook.sh --playbook notifications/apprise/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
