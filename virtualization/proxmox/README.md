# Proxmox

Proxmox Virtual Environment is a complete open-source platform for enterprise virtualization. With the built-in web interface you can easily manage VMs and containers, software-defined storage and networking, high-availability clustering, and multiple out-of-the-box tools using a single solution.

- [Official site](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview)
- [Source repository](https://git.proxmox.com/)
- [Documentation](https://pve.proxmox.com/pve-docs/)
- ~~Image repo~~
- ~~Other sites~~

## Requirements

- Free and Open source, preferably 0$ cost

## Tools

- [Proxmox Datacenter Manager](https://www.proxmox.com/en/products/proxmox-datacenter-manager/overview) - A centralized management solution to oversee and manage multiple nodes and clusters of Proxmox-based virtual environments.
- [ProxMenux](https://github.com/MacRimi/ProxMenux) - A management tool for Proxmox VE that simplifies system administration through an interactive menu, allowing you to execute commands and scripts with ease.
- [Proxmox VE Local](https://github.com/community-scripts/ProxmoxVE-Local) - A modern web-based management interface for Proxmox VE (PVE) helper scripts. This tool provides a user-friendly way to discover, download, and execute community-sourced Proxmox scripts locally with real-time terminal output streaming. No more need for curl -> bash calls, it all happens in your environment.
- [ProxSave](https://github.com/tis24dev/proxsave) - Backup tool for Proxmox PBS & PVE System Files with advanced features and notifications
- [PegaProx](https://pegaprox.com/) - A powerful web-based management interface for Proxmox VE clusters. Manage multiple clusters from a single dashboard with features like live monitoring, VM management, automated tasks, and more.

## Usage

- `configure-proxmox.yaml` - Proxmox specific apt repository setup (PVE 8 and 9), force IPv4 for apt, and a service working around the Intel NIC bug
- `configure-proxmox-lm-sensors.yaml` - Install `lm-sensors` and detect the sensors on the Proxmox nodes (needed for temperature monitoring, e.g. Pulse)
- `configure-proxmox-pulse.yaml` - Create a `pulse-monitor` role & user in PVE for [Pulse](../../monitoring/allinone/pulse/README.md)
- `configure-proxmox-terraform.yaml` - Create a `terraform` role & user in PVE and Linux, with SSH keys, for [Terraform](../../automation/terraform/README.md)
- `setup-packages-guest.yaml` - Install the `qemu-guest-agent` package on all VMs (`vms` group)

Run any of them with:

```bash
./common-ansible-run-playbook.sh --playbook virtualization/proxmox/<PLAYBOOK> --no-check
```

## Metrics, Alerts, Notifications

1. Set up the external InfluxDB streaming

    ```bash
    ./common-ansible-run-playbook.sh --playbook virtualization/proxmox/configure-proxmox-metrics.yaml --no-check
    ```

2. Load in any of the matching Grafana dashboards

    - [21988](https://grafana.com/grafana/dashboards/21988-proxmox-server/)
    - [17409](https://grafana.com/grafana/dashboards/17409-proxmox-vm-overview/)
    - [23309](https://grafana.com/grafana/dashboards/23309-proxmox-7-8-flux/)
    - [22559](https://grafana.com/grafana/dashboards/22559-proxmox-dashboard/)
    - [23164](https://grafana.com/grafana/dashboards/23164-proxmox-ve/)
    - [18127](https://grafana.com/grafana/dashboards/18127-proxmox-flux/)
    - [19119](https://grafana.com/grafana/dashboards/19119-proxmox-ve-cluster-flux/)
    - [15356](https://grafana.com/grafana/dashboards/15356-proxmox-cluster-flux/)

  Pay attention that there are dashboards that use InfluxDB but use `InfluxQL`, those will not work here, use these ones done with `Flux`.

  Some dashboards require a `Telegraf Collector` as well, so try to choose one that does not require such.
