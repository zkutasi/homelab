# Grimmory

A self-hosted library for your ebooks, comics, and audiobooks. Grimmory is an independent community fork of [BookLore](https://github.com/booklore-app/booklore).

- [Official site](https://grimmory.org/)
- [Source repository](https://github.com/grimmory-tools/grimmory)
- [Documentation](https://grimmory.org/docs/getting-started/)
- [Image repo](https://hub.docker.com/r/grimmory/grimmory)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |grimmory_db_root_password|M|The DB root password|
    |grimmory_db_user_password|M|The DB user password|
    |port_grimmory|M|The host port of the Grimmory web UI|
    |port_grimmory_mariadb|M|The host port of the Grimmory MariaDB database|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/grimmory/deploy-grimmory.yaml --no-check
```

Wait patiently for the database init/migration script to finish. It could take minutes.

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Since it is written in Java, the memory footprint is a bit higher than usual.
