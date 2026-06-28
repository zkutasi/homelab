# Calico WHisker

[Calico Whisker](https://docs.tigera.io/calico/latest/observability/view-flow-logs) - You can observe network traffic in your cluster by viewing flow logs in the Calico Whisker web console.

## The setup

Normally, Calico Whisker requires the Calico Tigera Operator, in which case Whisker is enabled by default. However Kubespray installs Calico in the manifest-only way, in which case it is a bit more difficult. Fortunately here is a [detailed description](https://www.tigera.io/blog/how-to-deploy-whisker-and-goldmane-in-manifest-only-calico-setups/) how to install Whisker in this case. Even more info is in [this github discussion](https://github.com/orgs/projectcalico/discussions/11445).

## Prerequisites

1. Calico installed in the Kubernetes cluster
2. Some settings in Kubespray
    1. Enable Calico Typha (this is a cache between Calico-Node and the KubeAPI server)
    2. Enable Typha TLS

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate Goldmane and Whisker-backend TLS certs using the Typha Kubernetes CA

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/eBPF/calico-whisker/generate-certs.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
