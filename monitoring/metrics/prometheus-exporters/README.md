# Prometheus exporters

There are a vast amount of different exporters for different purposes, common or niche.

## Requirements

- Free and Open source, preferably 0$ cost
- Seamlessly integrate into Prometheus

## Contenders

- [Node exporter](https://github.com/prometheus/node_exporter) - A Prometheus metrics compatible exporter about the Node info
- [Smartctl exporter](https://github.com/prometheus-community/smartctl_exporter) - A specific exporter for SMART data from `smartctl`. Also compatible with Windows too
- [Windows exporter](https://github.com/prometheus-community/windows_exporter) - A specific exporter for Windows systems, just like Node exporter, but for Windows
- [PVE Prometheus Exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) - Either install it on each PVE Host or in a docker remotely and specify the PVE targets. Not ideal though as PVE has built-in metrics solutions, but only for Graphite and InfluxDB targets.
- [Conntrack-exporter](https://github.com/hiveco/conntrack_exporter) - Exports the Linux conntrack network data as Prometheus metrics
