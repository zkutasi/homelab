# Qui

Supports multiple QBitTorrent instances in one UI

- [Official site](https://getqui.com/)
- [Source repository](https://github.com/autobrr/qui)
- [Documentation](https://getqui.com/docs/intro/)
- ~~Image repo~~
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
    ./common-ansible-run-playbook.sh --playbook torrenting/qui/deploy-qui.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
