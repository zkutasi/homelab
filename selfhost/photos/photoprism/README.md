# PhotoPrism

[PhotoPrism](https://www.photoprism.app/) - An AI-Powered Photos App for the Decentralized Web.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |photoprism_db_password|M|The password for the MariaDB|
    |photoprism_db_root_password|M|The root password for the MariaDB|
    |photoprism_admin_password|M|The initial Admin password for the app|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |photos_extra_mounts|O|The input/original photos folders|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook selfhost/photos/photoprism/deploy-photoprism.yaml --no-check
```

## Commands

## Notable comments
