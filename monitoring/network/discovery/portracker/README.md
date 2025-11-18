# Portracker

[Portracker](https://github.com/mostafa-wahied/portracker) - A small app to discover used ports and services. Also handles multi-server environments with Peer connections.

## The setup

Deploy the central GUI in the Kubernetes cluster and deploy to each Peer Host the app again, with connectivity to the central server.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |portracker_hostname|M|The hostname the peers can communicate with|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central UI

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the peer hosts

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/portracker/agents/deploy-portracker.yaml --no-check
```

### Configure the peers into the central UI

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/portracker/configure-portracker.yaml --no-check
```

## Commands

## Notable comments
