# Docker manager solutions

These applications can manage docker containers, docker-compose stacks or even docker swarm and/or Kubernetes clusters. Managing means they can read the status of the containers, start/stop/restart them, for docker compose, they can manage the compose-file and give an overall control and dashboard view of the various hosts you have that runs docker.

## Requirements

- Free and Open source, preferrably 0$ cost
- Centralized management with web GUI (Native UI is not OK)
- Agent-based, no need to open up the docker socket
- Ability to not fully manage docker-compose YAML files through the app, but just show them on the UI as is

## Contenders

## Honorable mentions

- [Incus](https://linuxcontainers.org/incus/)
- [1Panel](https://github.com/1Panel-dev/1Panel) - Seems chinese to me
- [DweebUI](https://www.dweebui.com/) - Abandoned a bit, last release was in 2024

### Portainer

[Official Site](https://www.portainer.io/)

The de facto standard in this space. Supports everything needed, the BE even more (like has the ability to show poutdated images like Watchtower)

Cons:

- It has a Community Edition (CE) and a Business Edition (BE), and many cool features are BE-only (for $)

### Dockge

[Official Site](https://dockge.kuma.pet/)

Cons:

- A bit simple
- It is more like to edit the docker-compose files, not to have an overview dashboard
- For me it causes 100% CPU utilization

### Dyrectorio

[Official Site](https://dyrector.io/)

### Yacht

[Official Site](https://yacht.sh/)

A WebUI for docker containers that focuses on templating.

Cons:

- A bit abandoned, last commit was in 2024

### Komodo

[Official Site](https://komo.do/)

It is a very versatile alternative to Portainer, fully open source, and more like a build system with those extra features.

Cons:

- Maybe too much for just looking at the docker compose stacks, but there are vast potentials in those extra features.
