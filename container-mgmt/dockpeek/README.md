# DockPeek

[DockPeek](https://github.com/dockpeek/dockpeek) - A lightweight, self-hosted Docker dashboard for quick access to your containers. Open web interfaces, view logs, monitor ports, and update images — all from one clean, intuitive interface. It automatically detects Traefik labels and works out of the box with zero configuration.

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

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/dockpeek/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. Deploy a docker socket proxy for each remote host, no agents required/possible

## Commands

## Notable comments
