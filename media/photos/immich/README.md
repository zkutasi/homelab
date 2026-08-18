# Immich

High performance self-hosted photo and video management solution.

- [Official site](https://immich.app/)
- [Source repository](https://github.com/immich-app/immich)
- [Documentation](https://docs.immich.app/overview/quick-start/)
- ~~Image repo~~
- ~~Other sites~~

Immich Power Tools - A unofficial immich client to provide better tools to organize and manage your immich account. Building it to speed up your workflows in Immich to organize your people and albums.

- ~~Official site~~
- [Source repository](https://github.com/immich-power-tools/immich-power-tools)
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |immich_db_password|M|The postgres database password|
    |immich_api_key|M|API key for external apps to access Immich|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |photos_mounts|O|The input/original photos folders|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/photos/immich/deploy-immich.yaml --no-check
```

Then Navigate to the User Settings, and generate an API key and set it as well.

## Metrics, Alerts, Notifications

## Commands

## Notable comments
