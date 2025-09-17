# Network UPS Tools

The UPS handling is based on [Network UPS Tools (NUT)](https://networkupstools.org/), which is a server, that coordinates triggers from the UPS, like it is on battwery power or back on the powerline. Clients can connect to this and decide what to do. Also Visualization is key, to see power consumption and battery-time left.

The UPS will be plugged into a single Host via USB.

## Requirements

- Full integration into the NUT ecosystem
- Prometheus/Grafana integration

## Contenders

- [NUT Exporter](https://github.com/DRuggeri/nut_exporter) - A Prometheus compatible exporter for the NUT Server
- [Nutify](https://github.com/DartSteven/Nutify) - A NUT Server and a dashboard as well, in one package
- [PeaNUT](https://github.com/Brandawg93/PeaNUT) - A tiny dashboard for the NUT Server
- [WebNUT](https://github.com/rshipp/webNUT) - A simple dashboard for the NUT Server. Pretty abandoned, last commit is in 2020.
- [NutAlert](https://github.com/rmfatemi/nutalert) - UPS monitoring and alering system
