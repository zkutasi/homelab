# PeaNUT

A tiny dashboard for Network UPS Tools

- Official site: NA
- Source repository: <https://github.com/Brandawg93/PeaNUT>
- Documentation: NA
- Image repo: <https://hub.docker.com/r/brandawg93/peanut>
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
    ./common-ansible-run-playbook.sh --playbook monitoring/nut/peanut/deploy-peanut.yaml --no-check
    ```

### Post deployment

1. Go to the Web UI and complete the Setup with the Wizard.

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- I have chosen `network_mode=host`, because otherwise I would need to give a very specific IP address to the Synology NUT Server as allowed remote hosts.
