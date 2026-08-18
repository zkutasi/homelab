# Guacamole

The Apache Guacamole proxy daemon (guacd), C API (libguac), and protocol support.

- [Official site](https://guacamole.apache.org/)
- [Source repository](https://github.com/apache/guacamole-server)
- [Documentation](https://guacamole.apache.org/doc/gug/)
- [Image repo](https://hub.docker.com/r/guacamole/guacd)
- ~~Other sites~~

## The setup

Deployed into the Kubernetes cluster.

## Prerequisites

- Cloud Native PG Operator installed

## Usage

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
