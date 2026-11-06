# Infrastructure components

There are a lot of components that are still required for the Kubernetes infrastructure to work for any deployment. These include:

- LoadBalancers
- Ingress Controllers
- CoreDNS and NodelocalDNS config
- ExternalDNS handlers
- Certificate Managers
- StorageClasses
- Cloud Native databases and storage servers
- Pod rebalancing

## Requirements

- Free and Open source, preferably 0$ cost
- Best-in-class solution
- Minimal overhead, as the infrastructure is relatively small/limited
- Possibly related to my work-stack

## Contenders

### Kubernetes Load Balancer

In order to access externally the cluster services and resources we somehow need LoadBalancer types to get IP addresses when they request for one. In the Cloud Native world, this is done by external Load Balancer services which set up routing and configure these LoadBalancer objects. But on Bare-metal self-hosted Kubernetes, there is no such thing.

- [MetalLB](https://metallb.io/) - This is what I have chosen as I work with this one, I know this one well enough.
- [Cilium](https://cilium.io/)
- [OpenELB](https://github.com/openelb/openelb)
- [LoxiLB](https://www.loxilb.io/)

### Ingress Controllers

In Kubernetes, above the LoadBalancer layer, Ingresses allow Layer7 access to HTTP endpoints, by exposing their own singular LoadBalancer and routing based on Fully Qualified Domain Names (FQDN). Here is a good list of such components: [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

- [Ingress-Nginx](https://github.com/kubernetes/ingress-nginx) - This is the original ingress shipped with Kubernetes, and compatible with many helm charts out of the box. Retired in March 2026, no longer maintained.
- [Contour](https://projectcontour.io/) - This is what I have chosen as I work with this one, I know this one well enough.
- [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/) - Another popular ingress among homelabbers

### CoreDNS and NodelocalDNS config

Normally, the regular installation has the following configuration for CoreDNS:

- Inside the Pod, the NodelocalDNS address is present in the `/etc/resolv.conf` (169.254.x.x). This is a DaemonSet and the address is non-routable, so the local instance will get it.
- The NodelocalDNS config forwards every known K8s FQDN to the CoreDNS IP but caches the results, and every unknown IP goes to the local `/etc/resolv.conf`, which is the router-given addresses -> This was bypassed and now forwarding everything to CoreDNS instead

    ```conf
        #forward . /etc/resolv.conf   # Replace this
        forward . 10.233.0.3 {        # With these lines
            force_tcp
        }
    ```

- In CoreDNS config, a new forwarding logic was added for the internal addresses to reach the local DNS server, UNTIL it is not directly in the router

    ```conf
        #forward . /etc/resolv.conf {   # Replace these lines
        #  prefer_udp
        #  max_concurrent 1000
        #}
        forward . 192.168.31.2 192.168.31.4 {   # With these lines
          policy random
          health_check 5s
          max_fails 3
          prefer_udp
          max_concurrent 1000
        }
    ```

This way NodelocalDNS still will act as a cache and will contain no logic, and CoreDNS can have additional zones defined to properly resolve.

This can be easily reflected in the Kubespray config, so the changes will be kept even after upgrades.

### ExternalDNS

When it comes to Ingresses and FQDNs, managing them by hand is a little bit cumbersome: One needs to set them up in the cluster, then after that register the FQDN-IP mapping in the local DNS Server too. This second step is automated using the [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) project.

### Certificate Management

Ingresses natively support TLS and mutual TLS, so even if the service exposed itself does not support it, on the exposure layer it can be protected just fine. Creating such certificates and placing them into Secrets is automatable. The de-facto standard is [cert-manager](https://github.com/cert-manager/cert-manager), which is capable to issue many kinds of certificates (self-signed or even LetsEncrypt ones).

### StorageClasses

Data is a tricky part in Kubernetes, due to the whole platform's distributed and network-based, API-driven nature. Luckily there are a few good projects to help us store some data. These include block-storage, file-system storage and even S3-style storage solutions.

- [Rook Ceph](https://rook.io/) - For Block storage, this is what I have chosen as I work with this one, I know this one well enough.
- [Longhorn](https://longhorn.io/) - Popular alternative choice instead of Rook, albeit it has a few issues still required to be worked out.

### Pod rebalancing

Kubernetes only places Pods when they are scheduled, and never moves them afterwards, even if the cluster becomes unbalanced (for example after a node restart or when new nodes are added).

- [Descheduler](https://github.com/kubernetes-sigs/descheduler) - Evicts Pods based on policies, so the scheduler can place them on more suitable nodes.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
