# BorgUI

Replace complex Borg Backup terminal commands with a beautiful web UI. Create, schedule, and restore backups with just a few clicks.

- [Official site](https://borgui.com/)
- [Source repository](https://github.com/karanhudia/borg-ui)
- [Documentation](https://docs.borgui.com/)
- [Image repo](https://hub.docker.com/r/ainullcode/borg-ui)
- ~~Other sites~~

## The setup

I only use the repository monitoring capabilities, as Borgmatic handles my daily backups perfectly fine.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |borgui_username|M|The Borg UI login username|
    |borgui_password|M|The Borg UI login password (the one set after changing the default)|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgui/deploy-borgui.yaml --no-check
    ```

### Post deployment

1. Login with `admin/admin123` default password and change it when prompted. Set the new credentials in `borgui_username` and `borgui_password`.
2. Register the Borgwarehouse repositories in Borg UI

    ```bash
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgui/configure-borgui-from-borgwarehouse.yaml --no-check
    ```

## Commands

## Notable comments
