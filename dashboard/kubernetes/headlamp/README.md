# Headlamp

[Headlamp](https://headlamp.dev/) - A Kubernetes web UI that is fully-featured, user-friendly and extensible

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments

- I had to bypass the authentication as it only supports OIDC and token-based ones. Used [this issue](https://github.com/kubernetes-sigs/headlamp/issues/1801) as inspiration.
