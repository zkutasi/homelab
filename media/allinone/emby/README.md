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

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |emby_embyignores|O|A list of `.embyignore` files to place on the host holding the media files|
    |emby_embyignores.destination|M|The media folder to put the `.embyignore` file into|
    |emby_embyignores.content|M|The content of the `.embyignore` file (the patterns to ignore)|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/emby/deploy-emby.yaml --no-check
    ```

### Post deployment

1. Configure ignored files

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/emby/configure-embyignore.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
