# Infrastructure components

There are a lot of components that are still required for the Kubernetes infrastructure to work for any deployment. These include:

- LoadBalancers
- Ingress Controllers
- ExternalDNS handlers
- Certificate Managers
- StorageClasses
- Cloud Native databases and storage servers

## Kubernetes Load Balancer

In order to access externally the cluster services and resources we somehow need LoadBalancer types to get IP addresses when they request for one. In the Cloud Native world, this is done by external Load Balancer services which set up routing and configure these LoadBalancer objects. But on Bare-metal self-hosted Kubernetes, there is no such thing.

### MetalLB

This is what I have chosen as I work with this one, I know this one well enough.

### Cilium

### OpenELB

### LoxiELB

## Ingress Controllers

In Kubernetes, above the LoadBalancer layer, Ingresses allow Layer7 access to HTTP endpoints, by exposing their own singular LoadBalancer and routing based on Fully Qualified Domain Names (FQDN). Here is a good list of such components: [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

### Ingress (Nginx)

This is the original ingress shipped with Kubernetes, and compatible with many helm charts out of the box.

### Contour & Envoy

This is what I have chosen as I work with this one, I know this one well enough.

### Traefik

## ExternalDNS

When it comes to Ingresses and FQDNs, managing them by hand is a little bit cumbersome: One needs to set them up in the cluster, then after that register the FQDN-IP mapping in the local DNS Server too. This second step is automated using the [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) project.

## Certificate Management

Ingresses natively support TLS and mutual TLS, so even if the service exposed itself does not support it, on the exposure layer it can be protected just fine. Creating such certificates and placing them into Secrets is automatable. The de-facto standard is [cert-manager](https://github.com/cert-manager/cert-manager), which is capable to issue many kinds of certificates (self-signed or even LetsEncrypt ones).

## StorageClasses

Data is a tricky part in Kubernetes, due to the whole platform's distributed and network-based, API-driven nature. Luckily there are a few good projects to help us store some data. These include block-storage, file-system storage and even S3-style storage solutions.

### Rook Ceph

For Block storage, this is what I have chosen as I work with this one, I know this one well enough.

### Longhorn

Popular alternative choice instead of Rook, albeit it has a few issues still required to be worked out.

### Minio

For S3 storage, this is what I have chosen as I work with this one. Though I need to learn a lot about it.
