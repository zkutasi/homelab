# docker-socket-proxy (readonly)

This deploys a Host-wide read-only instance of the docker-socket-proxy. If anything more complex is needed, consider deploying a specific one per app.

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

```bash
./common-ansible-run-playbook.sh --playbook basics/docker-socket-proxy/readonly/deploy-docker-socket-proxy-readonly.yaml --no-check
```

## Commands

## Notable comments
