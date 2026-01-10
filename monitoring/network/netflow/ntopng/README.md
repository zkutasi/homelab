# NtopNG

[NtopNG](https://www.ntop.org/) - A revamped, modern reincarnation of the original ntop. Web-based network monitoring.

## The setup

On the router-side that transfers all ingress and egress traffic into the local network, I have selected the port connected to my router and mirrored it onto the one next to it. Then a network appliance miniPC is placed there, whose sole purpose is to provide network-insights network-wide based on that mirrored traffic.

## Prerequisites

N/A

## Usage

### Ansible inventory setup

For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |ntopng_interface|M|The interface to listen on|
    |network_subnet|M|The network subnet that defines all of the machines' IP addresses, CIDR notation|

### Deploy the app

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/network/netflow/ntopng/deploy-ntopng.yaml --no-check
    ```

After logging in with `admin/admin`, you can change these credentials.

## Commands

## Notable comments
