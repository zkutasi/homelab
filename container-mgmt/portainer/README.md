# Portainer

Making Docker and Kubernetes management easy.

- [Official site](https://www.portainer.io/)
- [Source repository](https://github.com/portainer/portainer)
- [Documentation](https://docs.portainer.io/)
- Image repo:
  - [Central](https://hub.docker.com/r/portainer/portainer-ce)
  - [Agent](https://hub.docker.com/r/portainer/agent)
- ~~Other sites~~

## The setup

The central management server is deployed on the Kubernetes cluster, and it manages/observes the Pods and objects there too. All other Hosts in the system have the Portainer Agent installed and attached to the central management server as remote hosts, observing those too.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |portainer_hostname|M|The FQDN hostname of the portainer service|
    |portainer_access_token|M|An access token generated on the Portainer UI, to access its REST API|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook container-mgmt/portainer/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment of the central component

1. Generate an access token to access the REST API:
    1. Log into the UI
    2. Go to My Account (top right corner) -> Access token, and add a new one
    3. Place this access token into the inventory as `portainer_access_token` into the `all` group_vars file

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

## Metrics, Alerts, Notifications

## Commands

## Notable comments
