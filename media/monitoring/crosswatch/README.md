# Crosswatch

Synchronize your data across media servers, media agents and trackers. Keep your movies and shows in sync, no matter where you watch.

- [Official site](https://wiki.crosswatch.app/)
- [Source repository](https://github.com/cenodude/CrossWatch)
- [Documentation](https://wiki.crosswatch.app/)
- [Image repo](https://hub.docker.com/r/cenodude/crosswatch)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/monitoring/crosswatch/deploy-crosswatch.yaml --no-check
```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
