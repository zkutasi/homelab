# Glance

[Glance](https://github.com/glanceapp/glance) - A self-hosted dashboard that puts all your feeds in one place

## The setup

Use it as a news outlet: RSS feeds, videos, github repo checks, subreddits, markets, etc... No need to watch host metrics or check for services and docker stats, other tools do them much better.

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
./common-ansible-run-playbook.sh --playbook dashboard/glance/deploy-glance.yaml --no-check
```

## Commands

## Notable comments
