# BookOrbit

[BookOrbit](https://bookorbit.app/) - A self-hosted library management and reading platform for ebooks, PDFs, audiobooks, and comics.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |bookorbit_bootstrap_token|M||
    |bookorbit_jwt_secret|M||
    |bookorbit_postgres_password|M|The DB password|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |books_mount|M|The folder to mount into the container for books|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/bookorbit/deploy-bookorbit.yaml --no-check
```

## Commands

## Notable comments

- Has out-of-the-box migration from BookLore & Grimmory.
