# LibreSpeed

[LibreSpeed](https://librespeed.org/) - A speedtester like the big ones, but open source, minimalist and small footprint.

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

```bash
./common-ansible-run-playbook.sh --playbook monitoring/network/testers/speedtest/librespeed/deploy-librespeed.yaml --no-check
```

## Commands

## Notable comments
