# YourLastFM

Turn your Last.fm scrobbles into a complete, private dashboard.

- ~~Official site~~
- [Source repository](https://github.com/Gomaink/your_lastfm)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/gomaink/your-lastfm)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_yourlastfm|M|The host port of the YourLastFM web UI|
    |yourlastfm_lastfm_api_key|M|A read-only last.fm API account key|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/yourlastfm/deploy-yourlastfm.yaml --no-check
```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
