# Contour

[Contour](https://projectcontour.io/) is an Ingress Controller based on the HTTPProxy YAML mianfest specification.

## The setup

The chosen ingress controller. Will provide access to HTTP endpoints.

## Prerequisites

N/A

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo bitnami/contour -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

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
