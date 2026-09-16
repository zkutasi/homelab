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

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgui/deploy-borgui.yaml --no-check
    ```

### Post deployment

Login with `admin/admin123` default password and change it when prompted.

## Commands

## Notable comments
