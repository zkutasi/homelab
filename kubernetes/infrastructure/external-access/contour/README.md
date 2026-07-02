# Contour

[Contour](https://projectcontour.io/) is an Ingress Controller based on the HTTPProxy YAML mianfest specification.

## The setup

The chosen ingress controller. Will provide access to HTTP endpoints.

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

## Commands

To test if MetalLB and Contour works, you can use this small test

```bash
kubectl apply -f https://projectcontour.io/examples/kuard-httpproxy.yaml
kubectl get po,svc,httpproxy -l app=kuard
```

Remove afterwards:

```bash
kubectl delete httpproxies.projectcontour.io kuard
kubectl delete service kuard
kubectl delete deployments.apps kuard
```

## Notable comments

- Contour & Envoy certs are valid only for a year! Contour expects upgrades once a year at least as the certs are regenerated in each helm upgrade.
