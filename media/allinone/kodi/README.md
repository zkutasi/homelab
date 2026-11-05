# Kodi

Kodi is an award-winning free and open source home theater/media center software and entertainment hub for digital media.

- [Official site](https://kodi.tv/)
- [Source repository](https://github.com/xbmc/xbmc)
- [Documentation](https://kodi.wiki/)
- ~~Image repo~~
- [Other sites](https://flathub.org/apps/tv.kodi.Kodi)

## The setup

Kodi runs natively on the HTPC, and is started automatically on login. The autostart waits for the Media Server containers (Emby, Plex, Jellyfin) and its API to be up first.

## Prerequisites

1. A desktop environment (GNOME) on the HTPC
2. The `kodi-wait-for-emby.sh` script deployed to the HTPC with `basics/scripts/setup-scripts.yaml`

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/kodi/deploy-kodi.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
