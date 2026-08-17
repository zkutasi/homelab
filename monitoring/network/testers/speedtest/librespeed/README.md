# LibreSpeed

Self-hosted Speed Test for HTML5 and more. Easy setup, examples, configurable, mobile friendly. Supports PHP, Node, Multiple servers, and more

- Official site: <https://librespeed.org/>
- Source repository: <https://github.com/librespeed/speedtest>
- Documentation: NA
- Image repo: NA
- Other sites: NA

## The setup

To use this tool, one really needs remote servers to test against, the frontend is just a shell and standalone mode is not really testing the internet speeds with 0 servers given.

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
    ./common-ansible-run-playbook.sh --playbook monitoring/network/testers/speedtest/librespeed/deploy-librespeed.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
