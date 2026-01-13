# Beszel

[Beszel](https://beszel.dev/) - A lightweight server monitoring platform that includes Docker statistics, historical data, and alert functions. It supports automatic backup, multi-user, OAuth authentication, and API access.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |beszel_hub_url|M|The Beszel Hub URL for the agents|
    |beszel_username|M|Beszel username (email)|
    |beszel_password|M|Beszel password|
    |beszel_token|M|The universal token to use for the agents|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |disk_devices|O|A list with the /dev devices to map into the agent container|

### Deploy the central hub

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. On the GUI, enable a permanent universal token in `Settings->Tokens & Fingerprints`, and set it into `beszel_token`

### Deploy the agents

```bash
./common-ansible-run-playbook.sh --playbook monitoring/beszel/agents/deploy-beszel-agent.yaml --no-check
```

## Commands

## Notable comments
