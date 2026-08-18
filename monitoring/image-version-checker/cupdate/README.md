# Cupdate

A service to keep container images secure and up-to-date. Made for Kubernetes and Docker.

- ~~Official site~~
- [Source repository](https://github.com/AlexGustafsson/cupdate)
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

I run this in my Kubernetes cluster and configured so that it watches all of the remote Hosts.

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

## Metrics, Alerts, Notifications

## Commands

## Notable comments
