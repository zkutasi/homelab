# Version-checker

[Jetstack Version-checker](https://github.com/jetstack/version-checker) is a metrics-exposing service to check for image versions.

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

2. Load in the [matching Grafana dashboard](https://grafana.com/grafana/dashboards/12833-version-checker/)

### Post deployment

## Commands

## Notable comments
