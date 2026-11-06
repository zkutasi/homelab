# DryDock

Open source container update monitoring — 23 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metrics, and a modern dashboard.

- [Official site](https://drydock.codeswhat.com/)
- [Source repository](https://github.com/CodesWhat/drydock)
- [Documentation](https://getdrydock.com/docs)
- [Image repo](https://hub.docker.com/r/codeswhat/drydock)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_drydock|M|The port of the Docker socket proxy on each host that Drydock connects to|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/drydock/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
