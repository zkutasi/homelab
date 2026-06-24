# Portabase

[Portabase](https://portabase.io/) - Database backup & restore tool for PostgreSQL, MySQL, MariaDB, Firebird SQL, SQLite, MongoDB, Redis and Valkey

## The setup

Only agent-based architecture is supported!
Since I already want to expose relevant databases to be able to browse them, the single Agent is deployed next to the Dashboard UI in Kubernetes.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |portabase_url|M|The URL to access Portabase on|
    |portabase_secret|M||
    |portabase_edge_key|M|The central server's key for the agents|

### Deploy the central UI

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook storage/databases/portabase/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment of the central UI

1. Create a new Agent on the UI, and note the edge key of it

### Deploy the agent next to the central UI

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook storage/databases/portabase/agents/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

- Create an Organization
- Connect the Created Agent into your Organization
- Create a Storage Channel (for example S3)
- Connect the Storage Channel into your Organization
- Create a Project and select the databases from the Agents to connect to
- In the Project settings, drill down into the databases one by one, and set the following settings (little icons at the top)
  - Retention policy
  - Backup method (cron schedule)
  - Storage Policy (connect to your Storage Channel)

## Commands

## Notable comments

- Does not handle turning off certificate verification at any point: S3 endpoint must either be HTTP or with a known CA certificate, and also the Agent cannot connect to a self-signed certificate UI.
