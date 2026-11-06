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

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_shelfmark|M|The host port of the Shelfmark web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/shelfmark/deploy-shelfmark.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
