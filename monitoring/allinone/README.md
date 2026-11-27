# All-in-one monitoring

Monitoring solutions that collect, store and show data in one package, or collectors covering every signal.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/) - Grafana's collector for metrics, logs and traces
- [Beszel](https://beszel.dev/) - Lightweight server monitoring with history, Docker stats and alerts
- [Glances](https://nicolargo.github.io/glances/) - A top/htop alternative with a web UI and an API
- [OmniSight](https://demo-omnisight.caglaryalcin.com) - Monitors multiple platforms on a single page
- [Pulse](https://pulserelay.pro/) - Monitoring for Proxmox, Docker, Kubernetes, TrueNAS and vSphere

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
