# Immich

[Immich](https://immich.app/) - Easily back up, organize, and manage your photos on your own server. Immich helps you
browse, search and organize your photos and videos with ease, without sacrificing your privacy.

[Immich Power Tools](https://github.com/varun-raj/immich-power-tools) - A unofficial immich client to provide better tools to organize and manage your immich account. Building it to speed up your workflows in Immich to organize your people and albums.

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

## Commands

## Notable comments
