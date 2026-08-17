# Plex

Don’t just store your movies and music—experience it like never before. Plex personal media server magically scans and organizes your files, sorting your media intuitively and beautifully.

- Official site: <https://www.plex.tv/personal-media-server/>
- Source repository: NA
- Documentation: NA
- Image repo: <https://hub.docker.com/r/plexinc/pms-docker>
- Other sites: NA

Tautulli - The best web application to monitor, view analytics, and receive notifications about your Plex Media Server.

- Official site: <https://tautulli.com/>
- Source repository: <https://github.com/Tautulli/Tautulli>
- Documentation: <https://github.com/Tautulli/Tautulli/wiki>
- Image repo: <https://hub.docker.com/r/tautulli/tautulli>
- Other sites: NA

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
    ./common-ansible-run-playbook.sh --playbook media/allinone/plex/deploy-plex.yaml --no-check
    ```

### Post deployment

1. Configure ignored files

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/plex/configure-plexignore.yaml --no-check
    ```

2. Block plex.direct to enable localplay properly

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/allinone/plex/configure-unbound-allow-localplay.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Without a Plex Pass, the client has to be on the same Subnet as the Server. This makes docker bridge networking problematic as usually the host's Subnet is totally different than the docker bridges. Plex can set up ranges for local playback ONLY with a Plex Pass, so this totally does not work. The easiest solution is to set host-mode for the network.
- Plex behind PiHole & Unbound was problematic if accessed through the local DNS record, as it identified the access as Remote. A simple solutions is to block plex.direct from resolving, making it 0.0.0.0, and then everything shall work as expected.
