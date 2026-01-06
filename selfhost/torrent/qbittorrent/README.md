# QBitTorrent

[QBitTorrent](https://www.qbittorrent.org/) - One of the best Torrent clients: cross-platform, actively developed, modern architecture.

## The setup

Multiple clients (in docker) run on multiple hosts independently.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |qbittorrent_extra_mounts|O|Any mounts that should be attached to, to transfer data from/to|

### Deploy the app

Deploy the docker images first:

```bash
./common-ansible-run-playbook.sh --playbook selfhosting/torrent/qbittorrent/deploy-qbittorrent.yaml --no-check
```

Then some mild configuration can happen:

```bash
./common-ansible-run-playbook.sh --playbook selfhosting/torrent/qbittorrent/configure-qbittorrent.yaml --no-check
```

This does the following:

- Sets a completion-script that runs every time a torrent Completes.

## Commands

## Notable comments

There are various other cool projects to help manage things in a different way:

- [VueTorrent](https://github.com/VueTorrent/VueTorrent) - Built around Vue.JS. Has to be set as an alternative UI in QBitTorrent itself
- [QbitWebUI](https://github.com/Maciejonos/qbitwebui) - Similar to Qui, but less feature-rich. Also communicates via the QbitTorrent REST API, but currently with only one instance.
- [QbitController](https://github.com/Bartuzen/qBitController) - An Android App to control the torrent client.
- [Qbit Manage](https://github.com/StuffAnThings/qbit_manage) - A python tool to interact with the QbitTorrent API and do categorization, tagging and various other tedious things. Pretty opinionated.
