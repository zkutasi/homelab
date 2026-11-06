# Tugtainer

An application for automated Docker container updates with a web UI

- ~~Official site~~
- [Source repository](https://github.com/Quenary/tugtainer)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/quenary/tugtainer)
- ~~Other sites~~

## The setup

Deploy the central component in Kubernetes and handle all other Hosts with agents

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |tugtainer_agent_secret|M|A randomly generated secret shared between the central component and the agents|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/tugtainer/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

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
