# Kubernetes

[Kubernetes](https://kubernetes.io/) is a container orchestration and management solution with a huge learning curve and vast potentials. I have chosen to run K8s because I work with it daily and it helps me keep sharp with technology and improve my knowledge with the vast landscape of Cloud Native applications.

Here is a matrix that collects most of the possibilities and their capabilities: [Kubernetes Distributions & Installers Matrix Table](https://nubenetes.com/matrix-table/#).

## Requirements

- Free and Open source, preferably 0$ cost
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
2. Use the `docker-compose.yaml` file provided by the author and use one of the many template and deployment engines:
    - [Kompose](https://kompose.io/) - An official Kubernetes tool to migrate a docker compose file into Kubernetes manifests automatically. Problem is that it is severely limited even for a simple compose file and development is at a stall in 2025. Really only works as a blueprint for migrations.
    - [Cloud Development Kit for Kubernetes (cdk8s)](https://cdk8s.io/) - Use Python, Java, Typescript or Go to define your manifests. Every such CDK8s App synthetises into Kubernetes Manifests. It is an NPM app. Originally for AWS CDK. Part of CNCF.
    - [Timoni](https://timoni.sh/) and the [CUE language](https://cuelang.org/). Timoni is a helm-replacement (module=chart, bundle=IHC, instance=release), but CUE can be templated into YAML manifests themselves. CUE is a superset of JSON.
    - [Carvel](https://carvel.dev/) - The [ytt templating language](https://carvel.dev/ytt/) treats templates like true YAML, unlike Helm go-templates, based on YAML and Starlark. Carvel is a whole exosystem of apps, the kapp CLI tool to install them, and a few other helper tools too. Has strong ties to VMWare. Another disadvantage is that one would still need to write all those lengthy YAML files, and all boilerplate things.
    - [Pulumi](https://github.com/pulumi/pulumi) - Write IaC in any language. Supports 120+ platforms. Kind of a replacement for Terraform, due to it is able to do platform-level stuff as well.
    - [Grafana Tanka](https://tanka.dev/) and the [JSonnet configuration language](https://jsonnet.org/). The language comes from one of Google's 20% projects. It is an extension of JSON.
    - [DHall-Kubernetes](https://github.com/dhall-lang/dhall-kubernetes) and the [DHall language](https://github.com/dhall-lang/dhall-lang)
    - [KCL](https://github.com/kcl-lang/kcl) - Check the [comparison Wiki](https://www.kcl-lang.io/docs/user_docs/getting-started/intro) for a good explanation of these various languages. Also has a [CLI toolset](https://github.com/kcl-lang/cli)
3. Take a library chart and just configure to use a specific image and version, with parameters to set up the app (env vars, mounts, dependencies, etc...)
    - [TrueCharts](https://truecharts.org/) - A community driven project with a vast array of Charts. Not preferred because it is not official, but they update pretty regularly. They even have a library chart to create new Charts, but I haven't figured out how exactly to use it, as it is extremely complex
4. [Artifact Hub](https://artifacthub.io/) - Like Docker Hub, but for Helm Charts, from anyone

## Extra settings

KubeSpray is used to setup the cluster and install some basic tools, but there are some things that the setup is not doing.

```bash
./common-ansible-run-playbook.sh --playbook kubernetes/configure-k8s-hosts.yaml --no-check
```

## Tools

A lot of tools should be used with Kubernetes:

- [Kubectl](https://kubernetes.io/docs/reference/kubectl/) - The fundamental CLI tool to manage anything kubernetes-related
- [Helm](https://helm.sh/) - The Kubernetes package manager
- [Kustomize](https://github.com/kubernetes-sigs/kustomize) - Ability to modify Kubernetes manifests or even Helm charts via post-rendering, if something needs customization
- [Kompose](https://kompose.io/) - Convert existing Docker-compose YAML files into Kubernetes manifests. Perfect for converting any project into Kubernetes-native
- [Kubeconform](https://github.com/yannh/kubeconform) - Kubernetes Manifest validation
- [Krew](https://github.com/kubernetes-sigs/krew) - Extend kubectl with plugins

```bash
./common-ansible-run-playbook.sh --playbook kubernetes/deploy-k8s-tools.yaml --no-check
./common-ansible-run-playbook.sh --playbook kubernetes/configure-k8s-tools.yaml --no-check
```

### Notable comments

- The inotify kernel settings were not high enough and the root user (id 0) had already used 128 instances which is the max number per user by default. Setting this a little bit higher avoids having for example log-tailing to error with "failed to create fsnotify watcher: too many open files", or in Loki, all of the Containers logged this error too.
  - To figure this out, one great tool is the [inotify-info](https://github.com/mikesart/inotify-info), which helps you understand the limits and the actual uses. Just check out the git repo, build the tool and then copy the binary to the target host.
