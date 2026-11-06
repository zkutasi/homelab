# PhotoPrism

AI-Powered Photos App

- [Official site](https://www.photoprism.app/)
- [Source repository](https://github.com/photoprism/photoprism)
- [Documentation](https://docs.photoprism.app/)
- [Image repo](https://hub.docker.com/r/photoprism/photoprism)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |photoprism_db_password|M|The password for the MariaDB|
    |photoprism_db_root_password|M|The root password for the MariaDB|
    |photoprism_admin_password|M|The initial Admin password for the app|
    |port_photoprism|M|The host port of the PhotoPrism web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/photos/photoprism/deploy-photoprism.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

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
