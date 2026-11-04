# Nebula-sync

Synchronize configuration of multiple Pi-hole v6.x instances.

- ~~Official site~~
- [Source repository](https://github.com/lovelaze/nebula-sync)
- ~~Documentation~~
- [Image repo](https://github.com/lovelaze/nebula-sync/pkgs/container/nebula-sync)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pihole_address|M|The full URL to the Primary Pi-hole instance in order to call its API|
    |pihole_secondary_address|M|The full URL to the Secondary Pi-hole instance in order to call its API|
    |pihole_password|M|The password set up for Pi-hole, the same on both instances|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook networking/adblocking/nebula-sync/deploy-nebula-sync.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
