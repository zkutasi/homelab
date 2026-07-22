# Mailrise

[Mailrise](https://mailrise.xyz/) - An SMTP gateway for Apprise notifications.

## The setup

Legacy apps using sendmail for example should send the messages into this SMTP proxy, which in turn creates Apprise notifications and spread the notifications accordingly.

## Prerequisites

1. Apprise installed
2. Mail system is set up (`setup-mail.yaml`)

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook notifications/mailrise/deploy-mailrise.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments

- The current config mandates that `<HOSTNAME>@mailrise.xyz` to be used as the recipient of any email
