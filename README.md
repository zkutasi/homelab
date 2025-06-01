# Homelab by Zoltan Kutasi

This repository is the home of my homelab and various scripts and tool configs for it.
Separate README files are placed in each selected folder to further emphasize how the specific component can be used.

## Overview

All of this is a work in progress. The hardware is more or less final,
but the Infrastructure as Code aspects will evolve as well as the hosted Services will grow.

### Hardware

- 1x Digitus DN-19 16U-6/6-SW Rack & a bunch of extra stuff for it
- 1x TP-Link TL-SG3428X 24 Port Gigabit Switch + 4 Port SFP+
- 1x TP-Link TL-SG2008P JetStream 8 Port Gigabit Smart Switch PoE
- 3x Dell Optiplex Micro 7060 with i5-8500T, 32GB RAM, 256GB SSD + 1TB SSD
- 1x Synology 216+II with 2x6TB HDD
- 1x Synology 224+ with 2x6TB HDD
- 2x Raspberry Pi 4 32GB SD
- 1x Eaton Ellipse PRO 1600 DIN 1600VA UPS
- 1x DigitalOcean VPS with 1 vCPU and 512MB RAM
- 1x Intel NUC Kit 7i3DNHE with i3-7100U, 16GB RAM, 500GB SSD
- 1x Intel NUC Kit 7i3BNH with i3-7100U, 8GB RAM, 256GB SSD
- 1x Self-built tower PC
  - Motherboard:
  - CPU: Intel Pentium G4560
  - RAM: 32GB
  - Storage: 256GB SSD + 8x 8TB HDD

And a bunch of smaller stuff. A diagram is in the works soon.
They consist of:

- 3x Dell Optiplex for a Kubernetes cluster
- 1x synology NAS for Music
- 1x Synology NAS for Documents, Photos and work related stuff
- 1x Raspberry Pi 4 for PiHole DNS
- 1x Raspberry Pi 4 for a Dashboard screen
- 1x VPS for essential things to host remotely (RustDesk for example)
- 1x NUC for HTPC purposes
- 1x NUC for private stuff (Windows)
- 1x Self-build tower PC for NAS with Movies, TVShows and co.

### Tech stacks

#### General tools

These are fundamental or general tools I built my infrastructure on or use it across the whole homelab.

| Logo | Name | Description |
|------|------|-------------|
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg" alt="Proxmox"> | [Proxmox](https://www.proxmox.com) | Provide the virtualization layer on bigger hardware units |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/hashicorp-terraform.svg" alt="Terraform"> | [Terraform](https://developer.hashicorp.com/terraform) | Create VMs on top of Proxmox |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/ansible.svg" alt="Ansible"> | [Ansible](https://www.ansible.com) | Automate bare metal provisioning and configuration on every machine |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/docker.svg" alt="Docker"> | [Docker](https://www.docker.com/) | Containerize everything, using Docker Compose |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/pi-hole.svg" alt="Pihole"> | [Pihole](https://pi-hole.net/) | Network-wide Ad Blocking and local DNS server |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/unbound.svg" alt="Unbound"> | [Unbound](https://www.nlnetlabs.nl/projects/unbound/about/) | Used with Pihole, to bypass public DNS Servers |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/ubuntu.svg" alt="Ubuntu Server"> | [Ubuntu Server](https://ubuntu.com/server) | Base OS for anything requiring one |

#### Kubernetes infrastructure stack

| Logo | Name | Description |
|------|------|-------------|
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/kubernetes.svg" alt="Kubernetes"> | [Kubernetes](https://kubernetes.io/) | Orchestrate containerized applications |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/helm.svg" alt="Helm"> | [Helm](https://helm.sh/) | A package manager for Helm |
| <img width="32" src="https://github.com/jetstack/cert-manager/raw/master/logo/logo.png" alt="Cert Manager"> | [Cert Manager](https://cert-manager.io/) | Cloud native certificate management, using self signed certs as well as Let's Encrypt ones |
| <img width="32" src="https://avatars.githubusercontent.com/u/60239468?s=200&v=4" alt="MetalLB"> | [MetalLB](https://metallb.io/) | Bare metal load-balancer for Kubernetes, for those External IPs |
| <img width="32" src="https://avatars.githubusercontent.com/u/54918165?s=200&v=4" alt="Contour"> | [Contour](https://projectcontour.io/) | Ingress Controller for the services exposed |
| <img width="32" src="https://github.com/kubernetes-sigs/external-dns/raw/master/docs/img/external-dns.png" alt="ExternalDNS"> | [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) | Synchronizes exposed Kubernetes Services and Ingresses (Contour HTTPProxies too) with DNS providers (Pihole too) |
| <img width="32" src="https://raw.githubusercontent.com/rook/artwork/master/logo/blue.svg" alt="Rook Ceph"> | [Rook Ceph](https://rook.io) | Cloud-Native Storage for Kubernetes |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" alt="Prometheus"> | [Prometheus](https://prometheus.io) | Collect metrics from all hosts with various exporters |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg" alt="Grafana"> | [Grafana](https://grafana.com) | Visualize metrics and other sources of information |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/loki.svg" alt="Loki"> | [Loki](https://grafana.com/oss/loki/) | A Log Aggregation system with Grafana integration |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana-alloy.svg" alt="Alloy"> | [Alloy](https://grafana.com/docs/alloy/latest/) | Collect logs from any source and transfer it to Loki |

#### Selfhosted apps

These are apps or services I self host myself in my infrastructure

| Logo | Name | Description |
|------|------|-------------|
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/rustdesk.svg" alt="RustDesk"> | [RustDesk](https://rustdesk.com/) | Open-Source Remote Desktop (to anywhere) with Self-Hosted Server Solutions (on the VPS) |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/network-ups-tools.svg" alt="Network UPS Tools"> | [Network UPS Tools](https://networkupstools.org/) | Connect the UPS to the internal Network and make it reusable |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/portainer.svg" alt="Portainer"> | [Portainer](https://www.portainer.io/) | Manage docker containers and compose stacks from a central place |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/komodo.svg" alt="Komodo"> | [Komodo](https://komo.do/) | A portainer alternative |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/cup-updates.svg" alt="Cup"> | [Cup](https://cup.sergi0g.dev) | Get notified of version updates of docker images |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/speedtest-tracker.svg" alt="Speedtest tracker"> | [Speedtest tracker](https://github.com/alexjustesen/speedtest-tracker) | Measure internet speed, latency and get notified if something happens |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/omnitools.svg" alt="Omni Tools"> | [Omni Tools](https://github.com/iib0011/omni-tools) | Various useful tools |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/it-tools.svg" alt="IT Tools"> | [IT Tools](https://github.com/CorentinTh/it-tools) | IT swiss army knife |
| <img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/convertx.png" alt="ConvertX"> | [ConvertX](https://github.com/C4illin/ConvertX) | Convert anything into something else |
