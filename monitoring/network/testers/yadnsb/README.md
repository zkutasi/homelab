# YaDNSb

A DNS performance testing IPv4, IPv6, DNS over HTTPS (DoH), DNS over TLS (DoT), and DNS over QUIC (DoQ).

- ~~Official site~~
- [Source repository](https://github.com/butialabs/yadnsb)
- ~~Documentation~~
- [Image repo](https://github.com/butialabs/yadnsb/pkgs/container/yadnsb)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_yadnsb|M|The host port of the YaDNSb web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

  ```bash
  ./common-ansible-run-playbook.sh --playbook monitoring/network/testers/yadnsb/deploy-yadnsb.yaml --no-check
  ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- The project was archived on 2026-07-11 (read-only, no successor named), so no further updates are expected.
