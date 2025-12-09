# Immich

[Immich](https://immich.app/) - Easily back up, organize, and manage your photos on your own server. Immich helps you
browse, search and organize your photos and videos with ease, without sacrificing your privacy.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |immich_db_password|M|The postgres database password|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |photos_extra_mounts|O|The input/original photos folders|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook selfhost/photos/immich/deploy-immich.yaml --no-check
```

## Commands

## Notable comments
