# Medialyze

[Medialyze](https://github.com/frederikemmer/MediaLyze) - Self-hosted media library analysis for large video collections

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
./common-ansible-run-playbook.sh --playbook media/medialyze/deploy-medialyze.yaml --no-check
```

## Commands

## Notable comments
