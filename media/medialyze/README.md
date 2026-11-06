# Medialyze

Self-hosted media library analysis for large media collections

- [Official site](https://www.medialyze.app/)
- [Source repository](https://github.com/frederikemmer/MediaLyze)
- ~~Documentation~~
- [Image repo](https://github.com/frederikemmer/medialyze/pkgs/container/medialyze)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_medialyze|M|The host port of the Medialyze web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/medialyze/deploy-medialyze.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
