# Network testers

Measuring connection quality over time: latency, packet loss, DNS performance and internet speed.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [SmokePing](https://oss.oetiker.ch/smokeping/) - Latency, latency distribution and packet loss measurement
- Speedtest trackers - Periodic or on-demand internet speed measurements
- [YaDNSb](https://github.com/butialabs/yadnsb) - DNS performance testing over UDP, DoH, DoT and DoQ

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
