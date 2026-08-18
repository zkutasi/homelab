# Version-checker

Kubernetes utility for exposing image versions in use, compared to latest available upstream, as metrics.

- ~~Official site~~
- [Source repository](https://github.com/jetstack/version-checker)
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

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

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [12833](https://grafana.com/grafana/dashboards/12833-version-checker/)

## Commands

## Notable comments
