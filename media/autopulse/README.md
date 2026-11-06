# Autopulse

automated lightweight service that updates media servers like Plex and Jellyfin based on notifications from media organizers like Sonarr and Radarr

- [Official site](https://autopulse.dancodes.online/autopulse/)
- [Source repository](https://github.com/dan-online/autopulse)
- [Documentation](https://autopulse.dancodes.online/autopulse/)
- [Image repo](https://github.com/dan-online/autopulse/pkgs/container/autopulse)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |autopulse_password|M|The password of the Autopulse login|
    |autopulse_username|M|The username of the Autopulse login|
    |autopulse_emby_apikey|O|An Emby API key for Autopulse, generated on Emby. If not set, Emby is not updated|
    |autopulse_jellyfin_apikey|O|A Jellyfin API key for Autopulse, generated on Jellyfin. If not set, Jellyfin is not updated|
    |plex_token|O|The Plex authentication token (X-Plex-Token) of the server. If not set, Plex is not updated|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/autopulse/deploy-autopulse.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- The default password for the Admin UI is `admin/password`
- If one uses a read-only `MergerFS` pool, there is a slight problem: while the download happens on the mapped filesystems, there will be no inotify events generated on the mergerFS filesystem. A simple touch on the mergerFS side triggers the watcher if it watches the `mergerFS` paths. So in theory, the torrent completion script shall touch the mergerFS path... however that one shall not even be mapped into the torrent client.
- Another issue is that currently the timestamp of the file is not checked... so if the file is present, then the trigger immediately is fired. Would be better to wait a bit for the download client to finish writing the file. But anyway this is problematic, as if the download gets stuck, and the age parameter threshold is reached, it still would update the targets. A better approach is to trigger a manual update via the torrent-completion script.
