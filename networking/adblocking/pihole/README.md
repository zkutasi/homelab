# PiHole

[PiHole](https://pi-hole.net/) is a popular DNS-based Network-wide Ad-blocking solution.

## The setup

A Pihole Host is running in the network, as a DNS resolver, capable to act as a complete replacement for the DNS servers used from the ISP.

Then [Unbound](https://nlnetlabs.nl/projects/unbound/about/) is used as a DNS resolver. There are two ways to resolve DNS:

- Forwarding mode means the DNS requests are forwarded to other big DNS resolvers, like Google (8.8.8.8) or Cloudflare (1.1.1.1) or Quad9 (9.9.9.9).
- Recursive mode means the DNS requests are truly resolved by visiting the authoritative DNS servers for the domain in question, in reverse order (so for example in case of mail.google.com, first the .com domain is resolved, then google.com, and then mail.google.com)

This Unbound instance is configured in Recursive mode.

## Prerequisites

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |pihole_password|M|The password set up for pihole|
    |pihole_dns_domain|O|The used domain suffix in the system. Default is "home".|
    |pihole_docker_network_3digit|O|The used docker network between PiHole and Unbound. Only give the first 3 digits, the last digit is not needed. Default is 172.21.200|

## Usage

Deploy the docker containers:

```bash
./common-ansible-run-playbook.sh --playbook networking/adblocking/pihole/deploy-pihole-unbound.yaml --no-check
```

To set up some local DNS entries, run this playbook too after:

```bash
./common-ansible-run-playbook.sh --playbook networking/adblocking/pihole/configure-pihole.yaml --no-check
```

## Commands

## Notable comments

- Some features had to be switched off as it caused major instability:
  - DNSSEC validation
  - IPv6
