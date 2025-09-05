# Monitoring solutions

Monitoring the Home infrastructure is essential, checking high CPU usage, error logs or SMART data for failure detection, but also to see if anything needs updating. And much more

## Requirements

- Collect logs from the host and from containers too
- Collect metrics from the hosts and from containers too
- Collect any additional data specific for a unique use-case
  - HDD and SSD/NVME SMART info
  - Power consumption
  - UPS info
- Collect running container and helm chart versions and notify about updates

## Contenders

### Agent based Logs & Metrics

- [Alloy](https://grafana.com/docs/alloy/latest/) - Collects logs, metrics (host and container) and is extensible with plugins too
- [Node exporter](https://github.com/prometheus/node_exporter) - A Prometheus metrics compatible exporter about the Node info
- [Smartctl exporter](https://github.com/prometheus-community/smartctl_exporter) - A specific exporter for SMART data from `smartctl`. Also compatible with Windows too
- [Windows exporter](https://github.com/prometheus-community/windows_exporter) - A specific exporter for Windows systems, just like Node exporter, but for Windows

### SNMP based Logs & metrics

It is best for Network switches, that cannot run extra agents at all. There are many-many SNMP collector solutions though, these are just a handful. Prerequisite is to set up the SNMP daemon on the target hosts.

- [Paessler PRTG](https://www.paessler.com/prtg)
- [LibreNMS](https://www.librenms.org/)
- [NetAlertX](https://netalertx.com/) - Scans the network, discovers Hosts and alerts for changes (new host for example)

### Version checkers

See the deeper README for these
