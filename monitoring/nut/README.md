# Network UPS Tools

The UPS handling is based on [Network UPS Tools (NUT)](https://networkupstools.org/), which is a server, that coordinates triggers from the UPS, like it is on battery power or back on the powerline. Clients can connect to this and decide what to do. Also Visualization is key, to see power consumption and battery-time left.

The UPS will be plugged into a single Host via USB.

## Requirements

- Full integration into the NUT ecosystem
- Prometheus/Grafana integration

## Contenders

- [NUT Exporter](https://github.com/DRuggeri/nut_exporter) - A Prometheus compatible exporter for the NUT Server
- [Nutify](https://github.com/DartSteven/Nutify) - A NUT Server and a dashboard as well, in one package
- [PeaNUT](https://github.com/Brandawg93/PeaNUT) - A tiny dashboard for the NUT Server
- [WebNUT](https://github.com/rshipp/webNUT) - A simple dashboard for the NUT Server. Pretty abandoned, last commit is in 2020.
- [NutAlert](https://github.com/rmfatemi/nutalert) - UPS monitoring and alerting system
- [NUT WebGUI](https://github.com/SuperioOne/nut_webgui) - Web interface for Network UPS Tools

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |nut_server_monitoring_password|M|The password of the NUT monitoring user|
    |nut_server_monitoring_username|M|The username of the NUT monitoring user (monuser)|
    |ups|O|If the host has a UPS attached, create this mapping|
    |ups.name|M|The name of the UPS to identify|
    |ups.driver|M|The USB driver to use. Use nut-scanner to discover the value required.|
    |ups.vendorid|M|The UPS Vendor ID. Use nut-scanner to discover the value required.|
    |ups.productid|M|The UPS Product ID. Use nut-scanner to discover the value required.|
    |ups.desc|M|The UPS description|
