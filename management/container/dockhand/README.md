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

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central component

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook management/container/dockhand/agents/deploy-dockhand.yaml --no-check
```

## Commands

## Notable comments

- A public API is not there yet in 1.0.6, so programmatically adding Hosts is not possible.
- Semantic version check is also on the roadmap as of 1.0.6
