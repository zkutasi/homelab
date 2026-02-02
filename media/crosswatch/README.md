# Crosswatch

[Crosswatch](https://github.com/cenodude/CrossWatch) - A synchronization engine that keeps your Plex, Jellyfin, Emby, SIMKL, Trakt, AniList, MDBList and Tautulli in sync.

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
./common-ansible-run-playbook.sh --playbook media/crosswatch/deploy-crosswatch.yaml --no-check
```

## Commands

## Notable comments
