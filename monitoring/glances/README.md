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

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/glances/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/glances/central/generate-configuration.yaml --no-check
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook monitoring/glances/agents/deploy-glances.yaml --no-check
```

## Commands

## Notable comments
