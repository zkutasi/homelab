# Kubernetes

[Official Site](https://kubernetes.io/) is a container orchestration and management solution with a huge learning curve and vast potentials. I have chosen to run K8s because I work with it daily and it helps me keep sharp with technology and improve my knowledge with the vast landscape of Cloud Native applications.

Here is a matrix that collects most of the possibilities and their capabilities: [Kubernetes Distributions & Installers Matrix Table](https://nubenetes.com/matrix-table/#).

## Requirements

- Free and Open source, preferrably 0$ cost
- A cluster installer capable of doing everything and so therefore highly configurable
- Native Kubernetes, no "playground"

## Contenders

### Kubeadm

[Official Site](https://kubernetes.io/docs/reference/setup-tools/kubeadm/). The Original tool to install a Kubernetes cluster.

Cons:

- It is a bit dated, but still widely used as it provides a low level understanding of what is going on.
- Heavy on the learning curve
- Troubleshooting is a pain
- Not supporting any tools, like monitoring, etc... to be installed

### Kops

[Official Site](https://kops.sigs.k8s.io/)

### Kubespray

[Official Site](https://github.com/kubernetes-sigs/kubespray). A modern way to install Kubernetes using Ansible and inventories. Has a vast amount of additional settings as well.

### Minikube

[Official Site](https://minikube.sigs.k8s.io/docs/). A Simple way to test Kubernetes and gain knowledge.

Cons:

- Not a native Kubernetes cluster, things work differently
- No HA, no ingress, etc...

### Kind

[Official Site](https://kind.sigs.k8s.io/). Intended for development and testing.

Cons:

- Not a native Kubernetes cluster, things work differently

### K0s

[Official Site](https://k0sproject.io/)

### K3s

[Official Site](https://k3s.io/)

### Rancher RKE

[Official Site](https://www.rancher.com/index.php/products/rke). From SUSE.

### MicroK8s

[Official SIte](https://microk8s.io/). The Kubernetes flavor from Ubuntu.
