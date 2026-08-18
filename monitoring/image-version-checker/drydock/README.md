# DryDock

Open source container update monitoring — 23 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metrics, and a modern dashboard.

- [Official site](https://drydock.codeswhat.com/)
- [Source repository](https://github.com/CodesWhat/drydock)
- Documentation: getdrydock.com/docs
- [Image repo](https://hub.docker.com/r/codeswhat/drydock)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

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
