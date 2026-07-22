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

### Post deployment

## Commands

- To send notifications, use some of these options (where `<TOKEN>` is the created configuration (`homelab` by default) and `<TAGNAME>` is the tag that defines the sending host):
  - `curl -k -X POST -d "body=Test Message" -d "type=info" -d "title=AAA" --tags=<TAGNAME> https://apprise.kubernetes.home/notify/<TOKEN>`
  - `apprises://apprise.kubernetes.home/<TOKEN>?tags=<TAGNAME>&verify=no`

## Notable comments

- I used tags to identify the sending host, as I have set up separate identifiers for each of them in the sub-push services, like Pushover
- Since I use a self-signed CA and certificates, I need to add `verify=no` or add this CA in the Mailrise container... I chose the former for now.
