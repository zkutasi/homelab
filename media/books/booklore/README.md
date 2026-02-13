# BookLore

[BookLore](https://booklore.org/) - A modern, beautiful interface designed for book lovers

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |booklore_db_root_password|M|The DB Root password|
    |booklore_db_user_password|M|The DB user password|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |books_mount|M|The folder to mount into the container for books|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/booklore/deploy-booklore.yaml --no-check
```

Wait patiently for the database init/migration script to finish. It could take minutes.

## Commands

## Notable comments
