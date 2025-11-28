# NetVisor

[NetVisor](https://netvisor.io/) - Scans your network, identifies hosts and services, and generates an interactive visualization showing how everything connects, letting you easily create and maintain network documentation.

## The setup

Deploy Agents to everywhere and deploy the Server into Kubernetes.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |netvisor_network_id|M|The Network ID the agents will report against|
    |netvisor_api_key|M|An API key for daemons to communicate with NetVisor Server|
    |netvisor_server_host|M|The host and port of the Netvisor server|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the central server

First deploy the app into the Kubernetes cluster:

```bash
./deploy-k8s.sh
```

Then go to the UI:

1. Register and log in
2. Go to `Networks` where you shall see one called `My Network`, note its ID and add it to the Ansible inventory as `netvisor_network_id`.
3. Generate a new API key for the daemons and add it to the Ansible inventory as `netvisor_api_key`.

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/discovery/netvisor/agents/deploy-netvisor-agent.yaml --no-check
```

## Commands

## Notable comments
