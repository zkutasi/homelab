# Komodo

[Komodo](https://komo.do/) is an emerging alternative for Portainer, but focusing more in a full build system not only just a container management webUI.

## The setup

The central UI portion of the Komodo ecosystem is deployed into a Kubernetes cluster.

Then each other docker host has an agent installed so the central UI collects information from all of them.

## Prerequisites

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |komodo_host|M|The FQDN hostname of the komodo service, to access the REST API|

## Usage

First deploy the central UI in Kubernetes. More on that later.

Then generate an access token to access the REST API:
1. Log into the UI
2. Go to Settings -> Profile -> API Keys, and add a new one, two things will be generated an API Key and a Secret
3. Place this API Key & Secret into the inventory (preferrably in group_vars/all.yaml) as `komodo_api_key` and `komodo_api_secret` into the `all` group_vars file

Then deploy the periphery agents to every host required

```bash
./run-playbook.sh --playbook playbooks/monitoring/container-managers/komodo/deploy-komodo.yaml --no-check
```

And finally register all of the hosts and existing stacks on the REST API

```bash
./run-playbook.sh --playbook playbooks/monitoring/container-managers/komodo/configure-komodo.yaml --no-check
```

## Notable comments
