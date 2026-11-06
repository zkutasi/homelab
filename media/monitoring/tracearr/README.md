# Tracearr

Real-time monitoring for Plex, Jellyfin, and Emby servers. Track streams, analyze playback, and detect account sharing from a single dashboard.

- [Official site](https://www.tracearr.com/)
- [Source repository](https://github.com/connorgallopo/tracearr)
- [Documentation](https://docs.tracearr.com/)
- [Image repo](https://github.com/connorgallopo/tracearr/pkgs/container/tracearr)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_tracearr|M|The host port of the Tracearr web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/monitoring/tracearr/deploy-tracearr.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Notably eats more resources than Tautulli & others combined, due to the Architecture, so keep this in mind
