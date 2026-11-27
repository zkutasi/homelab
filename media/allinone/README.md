# All-in-one media servers

Media servers that organize movies, shows, music and photos, and stream them to every device.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Emby](https://emby.media/) - Media server with automatic transcoding and streaming
- [Jellyfin](https://jellyfin.org/) - Free Software media system
- [Kodi](https://kodi.tv/) - Open source home theater and media center
- [Plex](https://www.plex.tv/personal-media-server/) - Media server that scans, organizes and streams the library

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
