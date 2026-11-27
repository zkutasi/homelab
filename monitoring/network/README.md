# Network monitoring

Watching the home network: device and service discovery, traffic analysis and connection quality.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- Network discovery - Periodic subnet scans for hosts, services and open ports
- Netflow - Traffic analysis: who talks to whom, with which protocol and how much
- Network testers - Latency, DNS and internet speed measurements
- [Texporter](https://github.com/kasd/texporter) - eBPF-based network traffic exporter for Prometheus

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
