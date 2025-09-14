# Kubernetes

[Kubernetes](https://kubernetes.io/) is a container orchestration and management solution with a huge learning curve and vast potentials. I have chosen to run K8s because I work with it daily and it helps me keep sharp with technology and improve my knowledge with the vast landscape of Cloud Native applications.

Here is a matrix that collects most of the possibilities and their capabilities: [Kubernetes Distributions & Installers Matrix Table](https://nubenetes.com/matrix-table/#).

## Requirements

- Free and Open source, preferrably 0$ cost
- A cluster installer capable of doing everything and so therefore highly configurable
- Native Kubernetes, no "playground"

## Contenders

### Installation

- [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) - The Original tool to install a Kubernetes cluster. Lots of cons though: It is a bit dated, but still widely used as it provides a low level understanding of what is going on. Heavy on the learning curve. Troubleshooting is a pain. Not supporting any tools, like monitoring, etc... to be installed.
- [Kops](https://kops.sigs.k8s.io/)
- [Kubespray](https://github.com/kubernetes-sigs/kubespray) - A modern way to install Kubernetes using Ansible and inventories. Has a vast amount of additional settings as well.
- [Minikube](https://minikube.sigs.k8s.io/docs/) - A Simple way to test Kubernetes and gain knowledge. But not a native Kubernetes cluster, things work differently: No HA, no ingress, etc...
- [Kind](https://kind.sigs.k8s.io/) - Intended for development and testing. Not a native Kubernetes cluster, things work differently
- [K0s](https://k0sproject.io/)
- [K3s](https://k3s.io/)
- [Rancher RKE](https://www.rancher.com/index.php/products/rke) - From SUSE.
- [MicroK8s](https://microk8s.io/) - The Kubernetes flavor from Ubuntu.

### App sources

In preference order:

1. Official Helm Chart sources (bigger projects all should have them)
2. [Kompose](https://kompose.io/) - A tool to migrate a docker compose file into Kubernetes manifests automatically
3. [TrueCharts](https://truecharts.org/) - A community driven project with a vast array of Charts. Not preferred because it is not official, but they update pretty regularly. They even have a library chart to create new Charts, but I haven't figured out how exactly to use it, as it is extremely complex

## Extra settings

KubeSpray is used to setup the cluster and install some basic tools, but there are some things that the setup is not doing.

### Usage

```bash
./common-run-playbook.sh --playbook kubernetes/setup-k8s-hosts.yaml --no-check
```

## Tools

A lot of tools should be used with Kubernetes:

- [Kubectl](https://kubernetes.io/docs/reference/kubectl/) - The fundamental CLI tool to manage anything kubernetes-related
- [Helm](https://helm.sh/) - The Kubernetes package manager
- [Kustomize](https://github.com/kubernetes-sigs/kustomize) - Ability to modify Kubernetes manifests or even Helm charts via post-rendering, if something needs customization
- [Kompose](https://kompose.io/) - Convert existing Docker-compose YAML files into Kubernetes manifests. Perfect for converting any project into Kubernetes-native
- [Kubeconform](https://github.com/yannh/kubeconform) - Kubernetes Manifest validation
- [Krew](https://github.com/kubernetes-sigs/krew) - Extend kubectl with plugins

### Notable comments

- The inotify kernel settings were not high enough and the root user (id 0) had already used 128 instances which is the max number per user by default. Setting this a little bit higher avoids having for example log-tailing to error with "failed to create fsnotify watcher: too many open files", or in Loki, all of the Containers logged this error too.
  - To figure this out, one great tool is the [inotify-info](https://github.com/mikesart/inotify-info), which helps you understand the limits and the actual uses. Just check out the git repo, build the tool and then copy the binary to the target host.
