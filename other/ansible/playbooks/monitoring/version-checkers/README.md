# Version checker solutions

These are applications designed to either only show if a container image is out of date, or even automatically uplift it.

## Requirements

- Ability not to auto-uplift, preferably just notify
- Free and Open source, preferrably 0$ cost
- Centralized management with web GUI (Native UI or CLI only is not OK)
- Agent-based, does not require to open up the docker socket

## Contenders

### Cup

[Official Site](https://github.com/sergi0g/cup)

Cons:

- Maybe too simple?

### Diun

[Official Site](https://crazymax.dev/diun/)

Cons:

- Only a CLI, no Web GUI

### What's Up Docker

[Official Site](https://github.com/getwud/wud)

Cons: 

- Requires opening up the whole docker socket

### Watchtower

[Official Site](https://containrrr.dev/watchtower/)

Cons:

- Abandoned? Last release is in 2023
