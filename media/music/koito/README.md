# Koito

A modern, themeable scrobbler that you can use with any program that scrobbles to a custom ListenBrainz URL

- [Official site](https://koito.io/)
- [Source repository](https://github.com/gabehf/koito)
- [Documentation](https://koito.io/guides/installation/)
- [Image repo](https://hub.docker.com/r/gabehf/koito)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |koito_postgres_password|M|The postgres password for Koito|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/koito/deploy-koito.yaml --no-check
```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
