# Dynamic DNS Clients

Dynamic DNS Clients I have investigated and used or using.

## Requirements

- Work with dynu.com, which is what I use
- Handle IPv4 and IPv6 seamlessly, both together and in either/or fashion
- Flexibility and fine-tuning in configuration

## Contenders

- [Ddclient](https://ddclient.net/) - The original software, but it really is a mess with configuring IPv6 due to its legacy. A lot of times it was not flexible enough for my DDNS Provider, sending the incorrect API request
- [Inadyn](https://github.com/troglobit/inadyn) - A relative new contender, but did not find any issues yet. Sadly, as of 2025 October, the project closed down (repo moved into read-only)
- [DDNS-updater](https://github.com/qdm12/ddns-updater) - Looks pretty abandoned at 2025, with 160 open issues and no releases past 2024

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ddns_hostname|M|The Dynamic DNS hostname to be updated with the correct IP|
    |ddns_password|M|The password to connect towards the DDNS service|
    |ddns_username|M|The username to connect towards the DDNS service|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ddns_aliases|O|The list of aliases to set the IP on. If empty, the DDNS client is not deployed on that host|
    |ddns_interface|M|The network interface to check for the IP address on|
    |ddns_ipv4|O|Specify whether IPv4 IPs are needed. Defaults to true.|
    |ddns_ipv6|O|Specify whether IPv6 IPs are needed. Defaults to true.|
