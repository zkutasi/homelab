# Tugtainer

An application for automated Docker container updates with a web UI

- Official site: NA
- Source repository: <https://github.com/Quenary/tugtainer>
- Documentation: NA
- Image repo: <https://hub.docker.com/r/quenary/tugtainer>
- Other sites: NA

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

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/tugtainer/agents/deploy-tugtainer.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- WARNING: it seems it only supports the "latest" tag and check newer images for those only. So no check for new versions of Semantic versioned containers.
