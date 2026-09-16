# Borgitory

Web UI for managing BorgBackup repositories with scheduling, monitoring, and cloud sync

- [Official site](https://borgitory.com)
- [Source repository](https://github.com/mlapaglia/Borgitory)
- [Documentation](https://borgitory.com)
- [Image repo](https://hub.docker.com/r/mlapaglia/borgitory)
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
    ./common-ansible-run-playbook.sh --playbook backups/borg/borgitory/deploy-borgitory.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments
