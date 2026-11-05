# DDclient

ddclient updates dynamic DNS entries for accounts on a wide range of dynamic DNS services.

- [Official site](https://ddclient.net/)
- [Source repository](https://github.com/ddclient/ddclient)
- [Documentation](https://docs.linuxserver.io/images/docker-ddclient/)
- [Image repo](https://hub.docker.com/r/linuxserver/ddclient)
- ~~Other sites~~

## The setup

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ddns_hostname|M|The Dynamic DNS hostname to be updated with the correct IP|
    |ddns_password|M|The password to connect towards the DDNS service|
    |ddns_username|M|The username to connect towards the DDNS service|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ddns_interface|M|The network interface to check for the IP address on|
    |ddns_aliases|O|The list of aliases to set the IP on. If empty, ddclient is not deployed on that host|

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
