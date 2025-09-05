# Version checker solutions

These are applications designed to either only show if a container image is out of date, or even automatically uplift it.

## Requirements

- Ability not to auto-uplift, preferably just notify
- Free and Open source, preferrably 0$ cost
- Centralized management with web GUI (Native UI or CLI only is not OK)
- Agent-based, does not require to open up the docker socket

## Contenders

- [Cup](https://github.com/sergi0g/cup) - A very simple one
- [Diun](https://crazymax.dev/diun/) - A very lightweight solution to the version checking. Only a CLI, no Web GUI
- [What's Up Docker](https://github.com/getwud/wud) - Requires opening up the whole docker socket, to support remote Hosts
- [Watchtower](https://containrrr.dev/watchtower/) - For a long time the de facto standard for this purpose. But abandoned? Last release is in 2023
