# Ad Blocking

Global ad blocking is a nice feature to take control of the home network and potentially control the users' activities too. Parental control, ads, tracking cookies and so on.

Often coupled with a DNS server, to not use public ones, and have full control of which DNS query is resolved in which way (DNS over TLS (DoT), DNS over HTTPS (DoH), etc.)

## Requirements

- Ability to block using lists, filters
- Customizable
- Able to use my own DNS server (forwarding or recursive)
- Have a dashboard

## Contenders

- [PiHole](https://pi-hole.net/) - One of the first projects to do network-wide ad-blocking.
- [Adguard Home](https://adguard.com/en/adguard-home/overview.html) - Very similar to PiHole, but adds more features, and more focuses on parental control features.
- [Unbound](https://nlnetlabs.nl/projects/unbound/about/) - A DNS Server that could be paired with any of the AdBlockers.
- [Technitium](https://technitium.com/dns/) - More like a serious DNS Server than an AdBlocker, but does both.

### Syncing multiple adblockers together

- PiHole
  - [Gravity Sync](https://github.com/vmstan/gravity-sync) - As from 2024, no longer maintained.
  - [Orbital Sync](https://github.com/mattwebbio/orbital-sync) - As from 2025, no longer maintained.
  - [Nebula Sync](https://github.com/lovelaze/nebula-sync)
- AdGuard Home
  - [Adguard Home Sync](https://github.com/bakito/adguardhome-sync)
- Technitium: No need to sync, as it can be installed in a clustered format, which syncs itself together
