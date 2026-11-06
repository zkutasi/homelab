# Portracker

An open source, self-hosted, real-time port monitoring and discovery tool.

- ~~Official site~~
- [Source repository](https://github.com/mostafa-wahied/portracker)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/mostafawahied/portracker)
- ~~Other sites~~

## The setup

Deploy the central GUI in the Kubernetes cluster and deploy to each Peer Host the app again, with connectivity to the central server.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_portracker|M|The host port of the Portracker agents|
    |portracker_hostname|M|The hostname the peers can communicate with|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the central UI

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/portracker/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the peer hosts

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/portracker/agents/deploy-portracker.yaml --no-check
    ```

### Post deployment

1. Register the agents

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/portracker/configure-portracker.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
