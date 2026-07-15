# Tracearr

[Tracearr](https://www.tracearr.com/) - Real-time monitoring for Plex, Jellyfin, and Emby servers. Track streams, analyze playback, and detect account sharing from a single dashboard.

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

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/monitoring/tracearr/deploy-tracearr.yaml --no-check
    ```

### Post deployment

## Commands

## Notable comments

- Notably eats more resources than Tautuli & other combined, due to the Architecture, so keep this in mind
