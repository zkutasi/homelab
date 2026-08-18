# Flux

Open and extensible continuous delivery solution for Kubernetes. Powered by GitOps Toolkit.

- [Official site](https://fluxcd.io/)
- [Source repository](https://github.com/fluxcd/flux2)
- [Documentation](https://fluxcd.io/flux/)
- ~~Image repo~~
- ~~Other sites~~

## The setup

To bootstrap a cluster, there are multiple options:

- Use the built in Flux CLI tool - This is the chosen approach at first as all the other modes are adding more abstraction layers.
- Use [Terraform](https://github.com/fluxcd/terraform-provider-flux)
- Use the [Flux Operator](https://github.com/controlplaneio-fluxcd/flux-operator) - This also adds Flux to the managed things, which is super cool

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

1. First deploy the Flux CLI tool

  ```bash
  ./common-ansible-run-playbook.sh --playbook automation/gitops/flux/deploy-flux-cli.yaml --no-check
  ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
