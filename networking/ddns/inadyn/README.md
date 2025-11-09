# Inadyn

[Inadyn](https://github.com/troglobit/inadyn) - A more modern take on DDNS.

## The setup

## Prerequisites

N/A

## Usage

### Ansible inventory setup

1. Add the following variables into the `group_vars/all` file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |ddns_hostname|M|The Dynamic DNS hostname to be updated with the correct IP|
    |ddns_password|M|The password to connect towards the DDNS service|
    |ddns_username|M|The username to connect towards the DDNS service|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |ddns_interface|M|The network interface to check for the IP address on|
    |ddns_aliases|O|The alias to set the IP on. Can be multiple for DDclient, can only be a single element list for Inadyn|
    |ddns_ipv6|O|Specify whether IPv6 IPs are needed or IPv4 ones. Defaults to true.|

### Deploy

```bash
./common-ansible-run-playbook.sh --playbook networking/ddns/inadyn/deploy-inadyn.yaml --no-check
```

## Commands

## Notable comments
