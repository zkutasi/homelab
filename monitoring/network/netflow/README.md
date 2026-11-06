# Netflow

Analyzing all of your local subnet's traffic is a great way to get insights which hosts talk to each other using what protocol/app, or how much traffic the hosts on the network consume. Also able to show some network-level issues.

**WARNING**: Such apps generate a LOT of Disk load, continuously running them is not advised as it will wear down the SSD. Either run them on HDDs, or in memory, or expect to buy a new SSD regularly.

## Requirements

- Ability to either work in a mirrored port-mode (when it gets the traffic via switch-port-mirroring) or in a router mode (when the machine itself acts as a network router and therefore sees everything)

## Contenders

- [NtopNG](https://www.ntop.org/) - Based on the original ntop back in the 1990s
- [Akvorado](https://github.com/akvorado/akvorado) - Graphical UI that receives flows and enriches them from various external sources
- [Elastiflow](https://www.elastiflow.com/) - Based on the Elastic stack (so quite resource intensive)
- [pmacct](http://www.pmacct.net/) - A set of passive network monitoring tools. Not as friendly user interface as others.
- [nfDump](https://github.com/phaag/nfdump)
- [SiLK](https://tools.netsa.cert.org/silk/index.html) - Tools for large networks from Carnegie Mellon University
- Grafana Flow - It is a made up name for a Telegraf-collector -> InfluxDB/Prometheus -> Grafana combo
- [SniffNet](https://sniffnet.net/) - A cool little desktop app that PCAPs all your packets and gets you insights about the traffic.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
