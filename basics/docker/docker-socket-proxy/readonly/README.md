# docker-socket-proxy (readonly)

This deploys a Host-wide read-only instance of the docker-socket-proxy. If anything more complex is needed, consider deploying a specific one per app.

- ~~Official site~~
- [Source repository](https://github.com/wollomatic/socket-proxy)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/wollomatic/socket-proxy)
- ~~Other sites~~

## The setup

## Prerequisites

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

```bash
./common-ansible-run-playbook.sh --playbook basics/docker/docker-socket-proxy/readonly/deploy-docker-socket-proxy-readonly.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
