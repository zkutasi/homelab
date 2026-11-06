# Gatus

Automated developer-oriented status page with alerting and incident support

- [Official site](https://gatus.io/)
- [Source repository](https://github.com/TwiN/gatus)
- [Documentation](https://gatus.io/docs)
- [Image repo](https://hub.docker.com/r/twinproduction/gatus)
- ~~Other sites~~

## The setup

The central Gatus runs in Kubernetes. A second, standalone Gatus instance runs in docker on the network monitoring host, checking with ICMP (over IPv4 and/or IPv6) that the Dynamic DNS names of all hosts resolve and respond.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |gatus_database_password|M|The Postgres database password|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the central component

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/gatus/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy the agents

1. Install the DDNS-checking instance with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/gatus/agents/deploy-gatus-agent.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
