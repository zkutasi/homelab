# Contour

Contour is a Kubernetes ingress controller using Envoy proxy.

- [Official site](https://projectcontour.io/)
- [Source repository](https://github.com/projectcontour/contour)
- [Documentation](https://projectcontour.io/docs/)
- [Helm Chart](https://github.com/projectcontour/helm-charts/tree/main/charts/contour)
- ~~Other sites~~

## The setup

The chosen ingress controller. Will provide access to HTTP endpoints.

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

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [21396](https://grafana.com/grafana/dashboards/21396-contour-ingress-metrics/)
    - [21402](https://grafana.com/grafana/dashboards/21402-contour-global-metrics/).
    - [23239](https://grafana.com/grafana/dashboards/23239-envoy-proxy-monitoring/)

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
