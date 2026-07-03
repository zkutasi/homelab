# Deepflow

[Deepflow](https://deepflow.io/) - eBPF Observability - Distributed Tracing and Profiling

## The setup

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

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Log into the separate Grafana with credentials `admin/deepflow`

## Commands

## Notable comments

- The whole project is a Chinese one. Major problem with this is that the github reported tickets are 90% chinese, the whole documentation is a bit all over the place (ChatGPT generated and/or translated), like if there would be a language barrier. Many defaults are Chinese: Timezone, NTP server, etc.
- There is a way to deploy agents outside of the Kubernetes cluster, even to monitor more clusters. However, this requires to use the `deepflow-cli` tool to generate a domain of some sort. It would be awesome if this could be done with some config instead.
- The `deepflow-ctl` by default tries to connect to the localhost, via a Nodeport of 30417, which is not really secure
- An [external Grafana](https://deepflow.io/docs/best-practice/production-deployment/#integrate-with-an-existing-grafana) can also be used, however it is a bit cumbersome: First unsigned plugins have to be loaded, then Custom pre-defined dashboards have to be loaded (or of course one can make their own custom ones as well)
- There are a lot of premade dashboards in the provided Grafana instance, however some of them are in Chinese, some of them are unusable if the technology is not used (ingress) and some of them like the Pod Maps are impossible to follow if the Services list get large.
- The whole project stores everything in Clickhouse DB, and there are a LOT of properties for a table. Creating new dashboards is of course possible, but I would not say it is easy: some of the properties are more than cryptic.
