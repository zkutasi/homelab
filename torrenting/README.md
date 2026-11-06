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

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
