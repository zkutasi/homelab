# Portainer

[Portainer](https://www.portainer.io/) is the de facto standard in container management user interfaces. It supports a wide range of architectures including Kubernetes, multi-host compatible and the containers can be observed, managed and configured even.

## The setup

The central UI portion of the Portainer ecosystem is deployed into a Kubernetes cluster, where it can monitor the local containers.

Then each other docker host has an agent installed so the central UI collects information from all of them.

## Prerequisites

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |portainer_host|M|The FQDN hostname of the portainer service|

## Usage

First deploy the central UI in Kubernetes. More on that later.

Then generate an access token to access the REST API:
1. Log into the UI
2. Go to My Account (top right corner) -> Access token, and add a new one
3. Place this access token into the inventory (preferrably in group_vars/all.yaml) as `portainer_access_token` into the `all` group_vars file

Then deploy the portainer agents to every host required

```bash
./run-playbook.sh --playbook playbooks/management/container/portainer/deploy-portainer.yaml --no-check
```

And finally register all of the hosts on the REST API

```bash
./run-playbook.sh --playbook playbooks/management/container/portainer/configure-portainer.yaml --no-check
```

## Notable comments
