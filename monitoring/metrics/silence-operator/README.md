# Silence-operator

silence-operator manages Alertmanager silences via custom resources

- ~~Official site~~
- [Source repository](https://github.com/giantswarm/silence-operator)
- ~~Documentation~~
- [Helm Chart](https://github.com/giantswarm/silence-operator/tree/main/helm/silence-operator)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

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

## Commands

## Notable comments

- Unfortunately Grafana's built in `Alert List` is not supporting Alertmanager, and there is no way to filter out Silenced alerts. So this operator only works if one uses AlertManager's UI or creates a custom one in Grafana with querying AlertManager.
