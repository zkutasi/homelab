# YourLastFM

[YourLastFM](https://github.com/Gomaink/your_lastfm) - Synchronizes scrobbles from Last.fm, stores them in a local SQLite database, and serves a web dashboard.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |yourlastfm_lastfm_api_key|M|A read-only last.fm API account key|
    |lastfm_username|M|The LastFM username|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/yourlastfm/deploy-yourlastfm.yaml --no-check
```

## Commands

## Notable comments
