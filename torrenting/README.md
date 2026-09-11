# Torrenting

Downloading via the bittorrent protocol is a fundamental way to get those Linux ISOs one desperately need.

Plus there are various side projects to provide a different management interface, to even multiple different torrent clients.

## Requirements

- A torrent client that can run headless in Docker, one independent instance per host
- A UI/monitoring layer that can aggregate multiple client instances into one place

## Contenders

- [qBittorrent](https://github.com/qbittorrent/qBittorrent)

### Alternative UIs/managers

- [Flood](https://github.com/jesec/flood) - A modern web UI for various torrent clients with a Node.js backend and React frontend.
- [Qui](https://github.com/autobrr/qui) - A fast, single-binary qBittorrent web UI: manage multiple instances, automate torrent workflows, and cross-seed across trackers.
