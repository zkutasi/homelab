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
./common-ansible-run-playbook.sh --playbook photos/photoprism/deploy-photoprism.yaml --no-check
```

## Commands

## Notable comments

- With the default settings, every Original picture will have 10-11 thumbnails, different sizes for different purposes. This is just how the App works: it creates multiple thumbs for indexing, AI, and sharing. One could dial it down if needed though, but only to a certain point:

    ```bash
    PHOTOPRISM_THUMB_UNCACHED: true
    PHOTOPRISM_THUMB_FILTER: linear
    PHOTOPRISM_THUMB_SIZE: 720
    PHOTOPRISM_THUMB_SIZE_UNCACHED: 720
    PHOTOPRISM_JPEG_SIZE: 720
    PHOTOPRISM_PNG_SIZE: 720
    PHOTOPRISM_JPEG_QUALITY: 80
    ```
