# Dynamic DNS Clients

Dynamic DNS Clients I have investigated and used or using.

## Requirements

- Work with dynu.com, which is what I use
- Handle IPv4 and IPv6 seamlessly, both together and in either/or fashion
- Flexibility and fine-tuning in configuration

## Contenders

- [Ddclient](https://ddclient.net/) - The original software, but it really is a mess with configuring IPv6 due to its legacy. A lot of times it was not flexible enuough for my DDNS Provider, sending the incorrect API request
- [Inadyn](https://github.com/troglobit/inadyn) - A relative new contender, but did not find any issues yet. Sadly, as of 2025 October, the project closed down (repo moved into read-only)
- [DDNS-updater](https://github.com/qdm12/ddns-updater) - Looks pretty abandoned at 2025, with 160 open issues and no releases past 2024
