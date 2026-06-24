# Portainer

[Portainer](https://www.portainer.io/) is the de facto standard in container management user interfaces. It supports a wide range of architectures including Kubernetes, multi-host compatible and the containers can be observed, managed and configured even.

## The setup

The central management server is deployed on the Kubernetes cluster, and it manages/observes the Pods and objects there too. All other Hosts in the system have the Portainer Agent installed and attached to the central management server as remote hosts, observing those too.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |portainer_hostname|M|The FQDN hostname of the portainer service|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central component

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment of the central component

1. Generate an access token to access the REST API:
    1. Log into the UI
    2. Go to My Account (top right corner) -> Access token, and add a new one
    3. Place this access token into the inventory (preferably in group_vars/all.yaml) as `portainer_access_token` into the `all` group_vars file

### Deploy the agents

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/portainer/agents/deploy-portainer-agent.yaml --no-check
    ```

### Post deployment

1. Register all of the hosts on the REST API

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/portainer/configure-portainer.yaml --no-check
    ```

## Commands

## Notable comments
