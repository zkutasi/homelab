# Wazuh

[Wazuh](https://wazuh.com/) is a completely open source Security Platform with Endpoint Security, Threat INtelligence and SecOps.

## The setup

Run the dashboard and the data-stack in Kubernetes, and install the agents into the remote endpoints.

## Prerequisites

N/A

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |wazuh_manager_hostname|M|The manager IP or hostname that the agents use to communicate with|
    |wazuh_registration_password|M|This is the enrollment password that the Agents use to enroll|

## Usage

### Install the central component

1. Generate certificates, with the official scripts:

    ```bash
    ./certs/indexer_cluster/generate_certs.sh
    ./certs/dashboard_http/generate_certs.sh
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Install the Agents

Deploy the agents to every host required

```bash
./common-ansible-run-playbook.sh --playbook security/siem/wazuh/deploy-wazuh-agent.yaml --no-check
```

## Commands

- To remove an agent or handle them in any way, from the CLI, use the following command

    ```bash
    kubectl exec -ti -n wazuh wazuh-manager-master-0 -- /var/ossec/bin/manage_agents
    ```

- To see information about an agent

    ```bash
    kubectl exec -ti -n wazuh wazuh-manager-master-0 -- /var/ossec/bin/agent_control -i <AGENT_ID>
    ```

## Notable comments

- Manager master and Worker Nodes require a LOT of disk. for me 10GB filled in in a few hours, and if the disk fills up, then agents cannot connect, and nothing works (and this is not noted anywhere). So be sure to graph the PVC usage and if those are at 100%, increase immediately.
- I opted for a native Linux installation of the agents, because the [dockerized version](https://github.com/wazuh/wazuh-docker) is questionable, whether all of the features are usable or not: after all a dockerized agent cannot access anything on the host that is not explicitly allowed, and allowing everything is just way too cumbersome. Even the Wazuh dashboard only utilizes binary service agents, not the dockerized one.
- Also the agent installation is based on the one-liner install that the Wazuh server offers, and not templating out the whole `ossec.conf` file, though fine-tuning on it might be required. Do it on your own later on.
