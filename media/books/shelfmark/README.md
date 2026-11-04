# ShelfMark

Shelfmark is a self-hosted web interface for searching and requesting books and audiobooks across multiple sources.

- ~~Official site~~
- [Source repository](https://github.com/calibrain/shelfmark)
- ~~Documentation~~
- [Image repo](https://github.com/calibrain/shelfmark/pkgs/container/shelfmark)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |books_mounts|O|A list of the book folders to mount into the container|
    |books_mounts.from|M|The folder on the host|
    |books_mounts.to|M|The sub-folder name under `/books` inside the container|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/shelfmark/deploy-shelfmark.yaml --no-check
```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
