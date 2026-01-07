# Version checkers & updaters

It is best to keep track of the image versions of containers and helm charts in order to update them regularly, even automatically.

## Requirements

- Possibility to just show the required updated but not necessarily auto-update the images
- Ability to handle remote hosts
- No need to open up the docker-socket at all (agent-based)
- Free and Open source, preferably 0$ cost
- Should handle all kinds of tags: semantic versions, latest, date-driven

## Contenders

- [Watchtower](https://github.com/containrrr/watchtower) - One of the earliest solutions for this problem, but seems abandoned, since 2023
  - A newer version is forked [by Nicholas Fedor](https://github.com/nicholas-fedor/watchtower)
  - Another fork [by Beatkind](https://github.com/beatkind/watchtower)
- [What's up Docker](https://getwud.github.io/wud/#/) - For multi-host setups, one requires to open up the docker socket on the particular host
- [Docker Image Update Notifier (DIUN)](https://crazymax.dev/diun/) - Command line only, no dashboard
  - [Diun Dash](https://github.com/orkaa/diun-dash) - Adds a multi-DIUN host dashboard, quite abandoned
- [Tugtainer](https://github.com/Quenary/tugtainer) - Multi-host support. But seems to only handle "latest" tags.
- [Hoister](https://github.com/HerrMuellerluedenscheid/hoister)
- [Dockcheck](https://github.com/mag37/dockcheck) - CLI only
- [Slackwatch](https://github.com/mag37/dockcheck)
- [Docking Station](https://github.com/LooLzzz/docking-station)
- [Dockwatch](https://github.com/Notifiarr/dockwatch)
- [Komodo](https://komo.do/) - Should also work, but for me it is not. Maybe because I am not managing my docker-compose files with it
- [Renovate Bot](https://docs.renovatebot.com/) - A very modern way to handle this via CI/CD automation and Infra as Code (IaC)
- [Argus](https://github.com/release-argus/Argus) - A whole release-notification system
- [Cup](https://cup.sergi0g.dev/docs) - Very lightweight, with dashboard and remote host abilities. No Kubernetes support sadly (yet).
- [Cupdate](https://github.com/AlexGustafsson/cupdate) - For Kubernetes or docker hosts
- [Jetstack Version Checker](https://github.com/jetstack/version-checker) - Expose the versions discovered as metrics, so a Grafana dashboard can be built around them.
