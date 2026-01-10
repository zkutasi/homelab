# Docker manager solutions

These applications can manage docker containers, docker-compose stacks or even docker swarm and/or Kubernetes clusters. Managing means they can read the status of the containers, start/stop/restart them, for docker compose, they can manage the compose-file and give an overall control and dashboard view of the various hosts you have that runs docker.

## Requirements

- Free and Open source, preferably 0$ cost
- Centralized management with web GUI (Native UI is not OK)
- Agent-based, no need to open up the docker socket
- Ability to not fully manage docker-compose YAML files through the app, but just show them on the UI as is

## Contenders

- [Portainer](https://www.portainer.io/) - The de facto standard in this space. Supports everything needed, the BE even more (like has the ability to show poutdated images like Watchtower).
- [Dockge](https://dockge.kuma.pet/) - A simple one. It is more like to edit the docker-compose files, not to have an overview dashboard. For me it caused 100% CPU utilization
- [Dyrectorio](https://dyrector.io/)
- [Yacht](https://yacht.sh/) - A WebUI for docker containers that focuses on templating. A bit abandoned, last commit was in 2024
- [Komodo](https://komo.do/) - It is a very versatile alternative to Portainer, fully open source, and more like a build system with those extra features. Maybe too much for just looking at the docker compose stacks, but there are vast potentials in those extra features.
- [Incus](https://linuxcontainers.org/incus/)
- [1Panel](https://github.com/1Panel-dev/1Panel) - Seems chinese to me
- [DweebUI](https://www.dweebui.com/) - Abandoned a bit, last release was in 2024
- [DockHand](https://dockhand.pro) - A modern take on docker management, for homelabs mostly. Low footprint, but can do version checking, start/stop, log-streaming, real-time usage metrics and more.
- [DockPeek](https://github.com/dockpeek/dockpeek) - Yet another one, this works only agentless, opening up the docker sockets for multiple hosts. Very minimalistic.
