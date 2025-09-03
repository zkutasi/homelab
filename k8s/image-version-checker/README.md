# Version checkers & updaters

It is best to keep track of the image versions of containers and helm charts in order to update them regularly, even automatically.

## Requirements

- Possibility to just show the required updated but not necessarily auto-update the images
- Ability to handle remote hosts
- No need to open up the docker-socket at all (agent-based)
- Free and Open source, preferrably 0$ cost
- Should handle all kinds of tags: semantic versions, latest, date-driven

## Contenders

- [Watchtower](https://github.com/containrrr/watchtower), one of the earliest solutions for this problem, but seems abandoned, since 2023
  - A newer version is forked [by Nicholas Fedor](https://github.com/nicholas-fedor/watchtower)
  - Another fork [by Beatkind](https://github.com/beatkind/watchtower)
- [What's up Docker](https://getwud.github.io/wud/#/), for multi-host setups, one requires to open up the docker socket on the particular host
- [Docker Image Update Notifier (DIUN)](https://crazymax.dev/diun/), Command line only, no dashboard
- [Hoister](https://github.com/HerrMuellerluedenscheid/hoister)
- [Dockcheck](https://github.com/mag37/dockcheck), CLI only
- [Slackwatch](https://github.com/mag37/dockcheck)
- [Docking Station](https://github.com/LooLzzz/docking-station)
- [Dockwatch](https://github.com/Notifiarr/dockwatch)
- [Komodo](https://komo.do/), should also work, but for me it is not. Maybe because I am not managing my docker-compose files with it
- [Renovate Bot](https://docs.renovatebot.com/), a very modern way to handle this via CI/CD automation and Infra as Code (IaC)
- [Argus](https://github.com/release-argus/Argus), a whole release-notification system
- [Cup](https://cup.sergi0g.dev/docs), very lightweight, with dashboard and remote host abilities. No Kubernetes support sadly (yet).
- [Cupdate](https://github.com/AlexGustafsson/cupdate), for Kubernetes or docker hosts
