# External access

Reaching the Kubernetes Apps from outside the cluster: load balancer IPs, ingress, TLS certificates and DNS records.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Cert-manager](https://cert-manager.io/) - Provisions and renews TLS certificates in Kubernetes
- [Contour](https://projectcontour.io/) - Ingress controller using the Envoy proxy
- [External DNS](https://kubernetes-sigs.github.io/external-dns/latest/) - Configures external DNS servers from Kubernetes resources
- [MetalLB](https://metallb.io/) - Network load balancer for bare-metal Kubernetes

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
