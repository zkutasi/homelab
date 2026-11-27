# Prometheus exporters

Exporters expose metrics of hosts and Apps that don't speak Prometheus themselves.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Borgmatic-exporter](https://github.com/maxim-mityutko/borgmatic-exporter) - Borgmatic backup metrics
- [conntrack-exporter](https://github.com/hiveco/conntrack_exporter) - Network connection tracking
- [Helm-exporter](https://github.com/sstarcher/helm-exporter) - Helm release stats
- [K8s-ephemeral-storage-metrics](https://github.com/jmcgrath207/k8s-ephemeral-storage-metrics) - Kubernetes ephemeral storage usage
- [Kopia-exporter](https://github.com/ymettier/kopia_go_exporter) - Kopia backup repositories
- [Node-exporter](https://github.com/prometheus/node_exporter) - Machine metrics
- [NUT Exporter](https://github.com/DRuggeri/nut_exporter) - UPS data from Network UPS Tools
- [Pihole-exporter](https://github.com/eko/pihole-exporter) - Pi-hole ad blocker stats
- [Pkg-exporter](https://github.com/margau/pkg-exporter) - Pending APT package updates
- [pve-exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) - Proxmox VE cluster information
- [Qbittorrent-exporter](https://github.com/martabal/qbittorrent-exporter) - qBittorrent stats
- [Smartctl-exporter](https://github.com/prometheus-community/smartctl_exporter) - Disk SMART data
- [Urbackup-exporter](https://github.com/ngosang/urbackup-exporter) - UrBackup backup system
- [Windows-exporter](https://github.com/prometheus-community/windows_exporter) - Windows machine metrics
- [X509-certificate-exporter](https://github.com/enix/x509-certificate-exporter) - X.509 certificate expiry

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
