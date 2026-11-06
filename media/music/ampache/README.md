# Ampache

A web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device.

- ~~Official site~~
- [Source repository](https://github.com/ampache/ampache)
- [Documentation](https://ampache.org/docs)
- [Image repo](https://hub.docker.com/r/ampache/ampache)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_ampache|M|The host port of the Ampache web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/ampache/deploy-ampache.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
