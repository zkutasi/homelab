# Autopulse

[Autopulse](https://autopulse.dancodes.online/autopulse/) - Automated scanning tool that integrates widely-used media management services with various media servers for seamless media organization

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

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/autopulse/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/autopulse/deploy-autopulse.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- The default password for the Admin UI is `admin/password`
- If one uses a read-only `MergerFS` pool, there is a slight problem: while the download happens on the mapped filesystems, there will be no inotify events generated on the mergerFS filesystem. A simple touch on the mergerFS side triggers the watcher if it watches the `mergerFS` paths. So in theory, the torrent completion script shall touch the mergerFS path... however that one shall not even be mapped into the torrent client.
- Another issue is that currently the timestamp of the file is not checked... so if the file is present, then the trigger immediately is fired. WOuld be better to wait a bit for the download client to finish writing the file. But anyway this is problematic, as if the download gets stuck, and the age parameter threshold is reached, it still would update the targets. A better approach is to trigger a manual update via the torrent-completion script.
