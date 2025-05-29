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

<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg"></td>
        <td><a href="https://www.proxmox.com">Proxmox</a></td>
        <td>Provide the virtualization layer on bigger hardware units</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/hashicorp-terraform.svg"></td>
        <td><a href="https://developer.hashicorp.com/terraform">Terraform</a></td>
        <td>Create VMs on top of Proxmox</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/ansible.svg"></td>
        <td><a href="https://www.ansible.com">Ansible</a></td>
        <td>Automate bare metal provisioning and configuration on every machine</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/docker.svg"></td>
        <td><a href="https://www.docker.com/">Docker</a></td>
        <td>Containerize everything, using Docker Compose</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/pi-hole.svg"></td>
        <td><a href="https://pi-hole.net/">Pihole</a></td>
        <td>Network-wide Ad Blocking and local DNS server</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/unbound.svg"></td>
        <td><a href="https://www.nlnetlabs.nl/projects/unbound/about/">Unbound</a></td>
        <td>Used with Pihole, to bypass public DNS Servers</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/ubuntu.svg"></td>
        <td><a href="https://ubuntu.com/server">Ubuntu Server</a></td>
        <td>Base OS for anything requiring one</td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
</table>

#### Kubernetes infrastructure stack

<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/kubernetes.svg"></td>
        <td><a href="https://kubernetes.io/">Kubernetes</a></td>
        <td>Orchestrate containerized applications</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/helm.svg"></td>
        <td><a href="https://helm.sh/">Helm</a></td>
        <td>A package manager for Helm</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/jetstack/cert-manager/raw/master/logo/logo.png"></td>
        <td><a href="https://cert-manager.io/">Cert Manager</a></td>
        <td>Cloud native certificate management, using self signed certs as well as Let's Encrypt ones</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/60239468?s=200&v=4"></td>
        <td><a href="https://metallb.io/">MetalLB</a></td>
        <td>Bare metal load-balancer for Kubernetes, for those External IPs</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/54918165?s=200&v=4"></td>
        <td><a href="https://projectcontour.io/">Contour</a></td>
        <td>Ingress Controller for the services exposed</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/kubernetes-sigs/external-dns/raw/master/docs/img/external-dns.png"></td>
        <td><a href="https://github.com/kubernetes-sigs/external-dns">ExternalDNS</a></td>
        <td>Synchronizes exposed Kubernetes Services and Ingresses (Contour HTTPProxies too) with DNS providers (Pihole too)</td>
    </tr>
    <tr>
        <td><img width="32" src="https://raw.githubusercontent.com/rook/artwork/master/logo/blue.svg"></td>
        <td><a href="https://rook.io">Rook Ceph</a></td>
        <td>Cloud-Native Storage for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg"></td>
        <td><a href="https://prometheus.io">Prometheus</a></td>
        <td>Collect metrics from all hosts with various exporters</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg"></td>
        <td><a href="https://grafana.com">Grafana</a></td>
        <td>Visualize metrics and other sources of information</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/loki.svg"></td>
        <td><a href="https://grafana.com/oss/loki/">Loki</a></td>
        <td>A Log Aggregation system with Grafana integration</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana-alloy.svg"></td>
        <td><a href="https://grafana.com/docs/alloy/latest/">Alloy</a></td>
        <td>Collect logs from any source and transfer it to Loki</td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
</table>

#### Selfhosted apps

These are apps or services I self host myself in my infrastructure

<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/rustdesk.svg"></td>
        <td><a href="https://rustdesk.com/">RustDesk</a></td>
        <td>Open-Source Remote Desktop (to anywhere) with Self-Hosted Server Solutions (on the VPS)</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/network-ups-tools.svg"></td>
        <td><a href="https://networkupstools.org/">Network UPS Tools</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/portainer.svg"></td>
        <td><a href="https://www.portainer.io/">Portainer</a></td>
        <td>Manage docker containers and compose stacks from a central place</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/komodo.svg"></td>
        <td><a href="https://komo.do/">Komodo</a></td>
        <td>A portainer alternative</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/cup-updates.svg"></td>
        <td><a href="https://cup.sergi0g.dev">Cup</a></td>
        <td>Get notified of version updates of docker images</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/speedtest-tracker.svg"></td>
        <td><a href="https://github.com/alexjustesen/speedtest-tracker">Speedtest tracker</a></td>
        <td>Measure internet speed, latency and get notified if something happens</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/omnitools.svg"></td>
        <td><a href="https://github.com/iib0011/omni-tools">Omni Tools</a></td>
        <td>Various useful tools</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/it-tools.svg"></td>
        <td><a href="https://github.com/CorentinTh/it-tools">IT Tools</a></td>
        <td>IT swiss army knife</td>
    </tr>
    <tr>
        <td><img width="32" src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/convertx.png"></td>
        <td><a href="https://github.com/C4illin/ConvertX">ConvertX</a></td>
        <td>Convert anything into something else</td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
    <tr>
        <td><img width="32" src=""></td>
        <td><a href="">xxxx</a></td>
        <td></td>
    </tr>
</table>
