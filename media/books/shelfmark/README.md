# ShelfMark

[Shelfmark](https://github.com/calibrain/shelfmark) - A unified web interface for searching and aggregating books and audiobook downloads from multiple sources - all in one place. Works out of the box with popular web sources, no configuration required. Add metadata providers, additional release sources, and download clients to create a single hub for building your digital library.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/books/shelfmark/deploy-shelfmark.yaml --no-check
```

## Commands

## Notable comments
