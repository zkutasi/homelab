# PiHole

A black hole for Internet advertisements

- Official site: <https://pi-hole.net/>
- Source repository: <https://github.com/pi-hole/docker-pi-hole>
- Documentation: NA
- Image repo: <https://hub.docker.com/r/pihole/pihole>
- Other sites: NA

Unbound - Unbound is a validating, recursive, caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards.

- Official site: <https://unbound.docs.nlnetlabs.nl/en/latest/>
- Source repository: <https://github.com/NLnetLabs/unbound>
- Documentation: <https://unbound.docs.nlnetlabs.nl/en/latest/>
- Image repo: <https://hub.docker.com/r/madnuttah/unbound>
- Other sites: NA

## The setup

A Pihole Host is running in the network, as a DNS resolver, capable to act as a complete replacement for the DNS servers used from the ISP.

Then [Unbound](https://nlnetlabs.nl/projects/unbound/about/) is used as a DNS resolver. There are two ways to resolve DNS:

- Forwarding mode means the DNS requests are forwarded to other big DNS resolvers, like Google (8.8.8.8) or Cloudflare (1.1.1.1) or Quad9 (9.9.9.9).
- Recursive mode means the DNS requests are truly resolved by visiting the authoritative DNS servers for the domain in question, in reverse order (so for example in case of mail.google.com, first the .com domain is resolved, then google.com, and then mail.google.com)

This Unbound instance is configured in Recursive mode.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |pihole_password|M|The password set up for pihole|
    |pihole_docker_network_3digit|M|The used docker network between PiHole and Unbound. Only give the first 3 digits, the last digit is not needed.|
    |pihole_address|M|The full URL to the Primary PiHole instance in order to call its API|
    |pihole_secondary_address|O|The full URL to the Secondary PiHole instance in order to call its API|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Switch off the built-in Stub DNS resolver that would prevent to attach to port 53

    ```bash
    ./common-ansible-run-playbook.sh --playbook networking/adblocking/configure-dnsserver-host.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook networking/adblocking/pihole/deploy-pihole-unbound.yaml --no-check
    ```

### Post deployment

1. To set up some local DNS entries, run this playbook too after:

```bash
./common-ansible-run-playbook.sh --playbook networking/adblocking/pihole/configure-pihole.yaml --no-check
```

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Some features had to be switched off as it caused major instability:
  - DNSSEC validation
  - IPv6
