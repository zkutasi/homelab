# APPNAME

[APPNAME](https://example.com) - A short introduction of the app

## The setup

Some sentences about the unique implementation aspects of the architecture chosen, based on best practices and the home network setup.

## Prerequisites

List of prerequisites.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

Describe how to deploy the app.

In case of Ansible:

```bash
./common-ansible-run-playbook.sh --playbook XXX/deploy-XXX.yaml --no-check
```

In case of Kubernetes:

1. Add the helm repository

    ```bash
    helm repo add XXX https://XXX
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo XXX/XXX -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

Some useful commands to handle some edge cases or frequent tasks

## Notable comments

Irks, quirks and design decisions explained.
