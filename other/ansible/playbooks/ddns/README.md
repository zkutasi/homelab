# Dynamic DNS Clients

Dynamic DNS Clients I have investigated and used or using.

## Requirements

- Work with dynu.com, which is what I use
- Handle IPv4 and IPv6 seamlessly, both together and in either/or fashion
- Flexibility and fine-tuning in configuration

## Contenders

### Ddclient

[Official Site](https://ddclient.net/)

Cons:

- It really is a mess with configuring IPv6 due to its legacy
- A lot of times it was not flexible enuough for my DDNS Provider, sending the incorrect API request

### Inadyn

[Official Site](https://github.com/troglobit/inadyn)

Cons:

- It is relative new, but did not find any issues yet

### DDNS-updater

[Official Site](https://github.com/qdm12/ddns-updater)

Cons:

- Looks pretty abandoned at 2025, with 160 open issues and no releases past 2024

## Ansible inventory setup

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
