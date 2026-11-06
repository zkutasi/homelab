# DDclient

ddclient updates dynamic DNS entries for accounts on a wide range of dynamic DNS services.

- [Official site](https://ddclient.net/)
- [Source repository](https://github.com/ddclient/ddclient)
- [Documentation](https://docs.linuxserver.io/images/docker-ddclient/)
- [Image repo](https://hub.docker.com/r/linuxserver/ddclient)
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

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook networking/ddns/ddclient/deploy-ddclient.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Configuring IPv6 is a mess due to its legacy, and it was not flexible enough for the DDNS provider, sending incorrect API requests.
