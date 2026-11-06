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

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |koito_apikey|O|A Koito API key, generated on the Koito UI. If not set, scrobbling to Koito is disabled|
    |koito_endpoint_url|O|The Koito endpoint URL, needed together with `koito_apikey`|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/koito/deploy-koito.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
