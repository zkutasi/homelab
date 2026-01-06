# Flood

[Flood](https://flood.js.org/) - A monitoring service for multiple Torrent clients.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook selfhost/torrent/flood/deploy-flood.yaml --no-check
```

## Commands

## Notable comments

- Compared to the official QBittorrent UI, it is extremely limited: no Categories, or Tags I like to use.
- For handling multiple UIs, one needs to log in as multiple users.
