# Portainer

[Portainer](https://www.portainer.io/) is the de facto standard in container management user interfaces. It supports a wide range of architectures including Kubernetes, multi-host compatible and the containers can be observed, managed and configured even.

## The setup

The central management server is deployed on the Kubernetes cluster, and it manages/observes the Pods and objects there too. All other Hosts in the system have the Portainer Agent installed and attached to the central management server as remote hosts, observing those too.

## Prerequisites

N/A

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |portainer_hostname|M|The FQDN hostname of the portainer service|

### Deploy the central component

1. Add the helm repository

    ```bash
    helm repo add portainer https://portainer.github.io/k8s/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo portainer/portainer -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

Generate an access token to access the REST API:

1. Log into the UI
2. Go to My Account (top right corner) -> Access token, and add a new one
3. Place this access token into the inventory (preferably in group_vars/all.yaml) as `portainer_access_token` into the `all` group_vars file

Then deploy the portainer agents to every host required

```bash
./common-ansible-run-playbook.sh --playbook management/container/portainer/agents/deploy-portainer-agent.yaml --no-check
```

### Configure Portainer server

Register all of the hosts on the REST API

```bash
./common-ansible-run-playbook.sh --playbook management/container/portainer/configure-portainer.yaml --no-check
```

## Commands

## Notable comments
