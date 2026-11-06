# Headlamp

A Kubernetes web UI that is fully-featured, user-friendly and extensible

- [Official site](https://headlamp.dev/)
- [Source repository](https://github.com/kubernetes-sigs/headlamp)
- [Documentation](https://headlamp.dev/docs/latest/)
- [Helm Chart](https://github.com/kubernetes-sigs/headlamp/tree/main/charts/headlamp)
- ~~Image repo~~
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/kubernetes/headlamp/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- I had to bypass the authentication as it only supports OIDC and token-based ones. Used [this issue](https://github.com/kubernetes-sigs/headlamp/issues/1801) as inspiration.
