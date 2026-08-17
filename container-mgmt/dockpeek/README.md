# DockPeek

Easily access your Docker container web interfaces and keep them up to date — across all your hosts.

- Official site: NA
- Source repository: <https://github.com/dockpeek/dockpeek>
- Documentation: NA
- Image repo: <https://hub.docker.com/r/dockpeek/dockpeek>
- Other sites: NA

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |dockpeek_secret_key|M||
    |dockpeek_username|M||
    |dockpeek_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/dockpeek/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Deploy a docker socket proxy for each remote host, no agents required/possible

## Metrics, Alerts, Notifications

## Commands

## Notable comments
