# Glance

A self-hosted dashboard that puts all your feeds in one place

- ~~Official site~~
- [Source repository](https://github.com/glanceapp/glance)
- [Documentation](https://github.com/glanceapp/glance/blob/main/docs/configuration.md)
- [Image repo](https://hub.docker.com/r/glanceapp/glance)
- ~~Other sites~~

## The setup

Use it as a news outlet: RSS feeds, videos, GitHub repo checks, subreddits, markets, etc... No need to watch host metrics or check for services and docker stats, other tools do them much better.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_glance|M|The host port of the Glance web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/glance/deploy-glance.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
