# Glances

[Glances](https://github.com/nicolargo/glances) - An Eye on your system. A top/htop alternative for GNU/Linux, BSD, Mac OS and Windows operating systems.

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

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/glances/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook monitoring/glances/agents/deploy-glances.yaml --no-check
```

### Post deployment

## Commands

## Notable comments
