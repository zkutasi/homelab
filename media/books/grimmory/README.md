# Grimmory

A self-hosted library for your ebooks, comics, and audiobooks. Grimmory is an independent community fork of [BookLore](https://github.com/booklore-app/booklore).

- Official site: <https://grimmory.org/>
- Source repository: <https://github.com/grimmory-tools/grimmory>
- Documentation: <https://grimmory.org/docs/getting-started/>
- Image repo: <https://hub.docker.com/r/grimmory/grimmory>
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |grimmory_db_root_password|M|The DB root password|
    |grimmory_db_user_password|M|The DB user password|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |books_mount|M|The folder to mount into the container for books|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/grimmory/deploy-grimmory.yaml --no-check
```

Wait patiently for the database init/migration script to finish. It could take minutes.

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Since it is written in Java, the memory footprint is a bit higher than usual.
