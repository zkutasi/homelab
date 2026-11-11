# Caretta

Instant K8s service dependency map, right to your Grafana.

- ~~Official site~~
- [Source repository](https://github.com/groundcover-com/caretta)
- ~~Documentation~~
- [Helm Chart](https://github.com/groundcover-com/caretta/tree/main/chart)
- ~~Image repo~~
- ~~Other sites~~

## The setup

## Prerequisites

- Grafana & Prometheus stack

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. The Prometheus configs are deployed together with the app by `./deploy-k8s.sh`

2. Load in any of the matching Grafana dashboards

    - [Official](https://github.com/groundcover-com/caretta/raw/refs/heads/main/chart/dashboard.json)

## Commands

## Notable comments

- The tool relies on Grafana to show the flows: the built network graph, and the traffic outliers. However this severely limits the capabilities of the tool and the Grafana dashboard setup is very hard to adapt.
