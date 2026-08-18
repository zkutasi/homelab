# Emby

Bringing all of your home videos, music, and photos together into one place has never been easier. Your personal Emby Server automatically converts and streams your media on-the-fly to play on any device.

- [Official site](https://emby.media/)
- ~~Source repository~~
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/emby/embyserver)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/emby/deploy-emby.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
