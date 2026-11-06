# Adguard Home

Network-wide ads & trackers blocking DNS server

- [Official site](https://adguard.com/adguard-home/overview.html)
- [Source repository](https://github.com/AdguardTeam/AdguardHome)
- [Documentation](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [Image repo](https://hub.docker.com/r/adguard/adguardhome)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |adguardhome_docker_network_3digit|M|The used docker network between AdguardHome and Unbound. Only give the first 3 digits, the last digit is not needed.|
    |port_adguardhome_init_webui_http|M|The host port of the AdGuard Home first-time setup web UI|
    |port_adguardhome_unbound|M|The host port of the bundled Unbound DNS resolver (TCP and UDP)|
    |port_adguardhome_webui_http|M|The host port of the AdGuard Home web UI over HTTP|
    |port_adguardhome_webui_https|M|The host port of the AdGuard Home web UI over HTTPS|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook networking/adblocking/adguard-home/deploy-adguard-home.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
