# Termix

[Termix](https://docs.termix.site/) - A clientless web-based server management platform with SSH terminal, tunneling, and file editing capabilities.

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
./common-ansible-run-playbook.sh --playbook remoting/termix/deploy-termix.yaml --no-check
```

## Commands

## Notable comments
