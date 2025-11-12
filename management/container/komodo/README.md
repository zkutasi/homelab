# Komodo

[Komodo](https://komo.do/) is an emerging alternative for Portainer, but focusing more in a full build system not only just a container management webUI.

## The setup

Run the Komodo server in Kubernetes and attach into the remote Docker hosts via Komodo's Periphery agent. No Kubernetes support yet though to manage those containers.

## Prerequisites

N/A

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |komodo_hostname|M|The FQDN hostname of the komodo service, to access the REST API|

### Deploy the central component

1. Create a `.komodo.env` file with the following content

    ```env
    KOMODO_DATABASE_URI=mongodb://<USER>:<PASSWORD>@<HOST>:<PORT>/komodo
    KOMODO_PASSKEY=<RANDOM_STRING>
    KOMODO_DATABASE_USERNAME=<USER>
    KOMODO_DATABASE_PASSWORD=<PASSWORD>
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. After going to the URL, enter your wanted credentials and hit the "Sign Up" button

### Deploy the agents

Generate an access token to access the REST API:

1. Log into the UI
2. Go to Settings -> Profile -> API Keys, and add a new one, two things will be generated an API Key and a Secret
3. Place this API Key & Secret into the inventory (preferably in group_vars/all.yaml) as `komodo_api_key` and `komodo_api_secret` into the `all` group_vars file

Then deploy the periphery agents to every host required

```bash
./common-ansible-run-playbook.sh --playbook management/container/komodo/periphery/deploy-komodo-periphery.yaml --no-check
```

And finally register all of the hosts and existing stacks on the REST API

```bash
./common-ansible-run-playbook.sh --playbook management/container/komodo/configure-komodo.yaml --no-check
```

## Commands

## Notable comments
