# Netflow

Analyzing all of your local subnet's traffic is a great way to get insights which hosts talk to each other using what protocol/app, or how much traffic the hosts on the network consume. Also able to show some network-level issues.

## Requirements

- Ability to either work in a mirrored port-mode (when it gets the traffic via switch-port-mirroring) or in a router mode (when the machine itself acts as a network router and therefore sees everything)

## Contenders

- [NtopNG](https://www.ntop.org/) - Based on the original ntop back in the 1990s
- [Akvorado](https://github.com/akvorado/akvorado) - Graphical UI that receives flows and enriches them from various external sources
- [Elastiflow](https://www.elastiflow.com/) - Based on the Elastic stack (so quote resource intensive)
- [pmacct](http://www.pmacct.net/) - A set of passive network monitoring tools. Not as friendly user interface as others.
- [nfDump](https://github.com/phaag/nfdump)
- [SiLK](https://tools.netsa.cert.org/silk/index.html) - Tools for large networks from Carnegie Mellon University
- Grafana Flow - It is a made up name for a Telegraph-collector -> InfluxDB/Prometheus -> Grafana combo
