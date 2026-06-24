# MetalLB

[MetalLB](https://metallb.io/) is a LoadBalancer implementation for Bare-metal, non-cloud Kubernetes clusters.

## The setup

The external access of the services inside the cluster will be provided on the IP level via MetalLB.

## Prerequisites

- A few IP addresses -> Set them in file `ipaddresspool.yaml`

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
