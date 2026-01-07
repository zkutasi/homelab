# Tugtainer

[Tugtainer](https://github.com/Quenary/tugtainer) - A relative newcomer to the field. Supports multiple hosts, automation or only notifications.

## The setup

Deploy the central component in Kubernetes and handle all other Hosts with agents

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

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/tugtainer/agents/deploy-tugtainer.yaml --no-check
```

## Commands

## Notable comments

- WARNING: it seems it only supports the "latest" tag and check newer images for those only. So no check for new versions of Semantic versioned containers.
