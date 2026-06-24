# DockHand

[DockHand](https://dockhand.pro) - A modern take on docker management, for homelabs mostly. Low footprint.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |dockhand_agent_token|M|The token to securely communicate with the Agent|
    |dockhand_database_password|M|The Database password to use|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/dockhand/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/dockhand/agents/deploy-dockhand.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments

- A public API is not there yet in 1.0.6, so programmatically adding Hosts is not possible.
- Semantic version check is also on the roadmap as of 1.0.6
