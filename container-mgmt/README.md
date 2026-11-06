# Docker manager solutions

These applications can manage docker containers, docker-compose stacks or even docker swarm and/or Kubernetes clusters. Managing means they can read the status of the containers, start/stop/restart them, for docker compose, they can manage the compose-file and give an overall control and dashboard view of the various hosts you have that runs docker.

## Requirements

- Free and Open source, preferably 0$ cost
- Centralized management with web GUI (Native UI is not OK)
- Agent-based, no need to open up the docker socket
- Ability to not fully manage docker-compose YAML files through the app, but just show them on the UI as is

## Contenders

- [Portainer](https://www.portainer.io/) - Making Docker and Kubernetes management easy.
- [Dockge](https://dockge.kuma.pet/) - A simple one. It is more like to edit the docker-compose files, not to have an overview dashboard. For me it caused 100% CPU utilization
- [Dyrectorio](https://dyrector.io/)
- [Yacht](https://dev.yacht.sh/) - A WebUI for docker containers that focuses on templating. Development continues under the [Yacht-sh](https://github.com/Yacht-sh/Yacht) organization
- [Komodo](https://komo.do/) - a tool to build and deploy software on many servers
- [Incus](https://linuxcontainers.org/incus/)
- [1Panel](https://github.com/1Panel-dev/1Panel) - A modern, open-source Linux server management panel. Mainly targets a Chinese audience: its homepage and parts of its documentation are in Chinese.
- [DweebUI](https://www.dweebui.com/) - Abandoned a bit, last release was in 2024
- [DockHand](https://dockhand.pro) - Docker management you will like.
- [DockPeek](https://github.com/dockpeek/dockpeek) - Easily access your Docker container web interfaces and keep them up to date — across all your hosts.
- [Sencho](https://sencho.io/) - Self-hosted Docker Compose management platform. For single or multi-host compose-first workflow.
- [Arcane](https://getarcane.app/) - Modern Docker Management, Designed for Everyone

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
