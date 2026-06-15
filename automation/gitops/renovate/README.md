# Renovate

[Renovate](https://www.mend.io/renovate/)

## The setup

The easiest way to run Renovate is to add it as an [App](https://github.com/apps/renovate) to your github profile. This runs Renovate on Mend's infrastructure, but you gain a very simple configuration.

There are multiple ways to run Renovate as a Helm Chart, which is preferred:

- The [OSS CLI tool](https://github.com/renovatebot/helm-charts) is the free open source version, which sets up a Cronjob and calls the CLI tool like that.
- [Community Edition (CE)](https://github.com/mend/renovate-ce-ee) - Adds a Kubernetes Operator, a job scheduler, a webhook listener. Many of these are useful only with multiple dependent repos. Also requires a (free) license.
- [Renovate Operator](https://github.com/mogenius/renovate-operator)

The latter variations are useful mostly for many repos, teams, and bigger projects. They also are heavier.

## Prerequisites

### Create a GitHub Personal Access Token (PAT)

This token has to have the following accesses:

- Contents - RW
- Dependabot Alerts - R
- Issues - RW
- Metadata - R
- Pull Requests - RW

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |github_pat_renovate|M|The Renovate Personal Access Token (PAT) to access the github repo|
    |github_homelab_repo|M|The repo's name|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

It is worth to know how to test newer renovate.json files without actually committing the changes, as Renovate by default clones the repo and works from there. This can be done by executing the Renovate tool in `local` mode, which will use the `renovate.json` from the local filesystem:

```bash
docker run --rm -it \
    --volume "${PWD}:/repo" \
    --workdir /repo \
    --env LOG_LEVEL=debug \
    renovate/renovate:43.220 \
    renovate \
    --platform=local \
    --dry-run=full \
    --print-config
    ```

## Notable comments

- In case of `values.yaml` files for TrueCharts, the image patterns must have the `image` string in them for Renovate to find. Make sure the naming follows this best practice. Single image values.yaml files shall use the `image` default key.
