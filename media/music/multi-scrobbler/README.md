# Multi-Scrobbler

[Multi-Scrobbler](https://example.com) - A short introduction of the app

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |multiscrobbler_baseurl|M|The Callback URL used by interactive login sites|
    |multiscrobbler_lastfm_api_key|M|The LastFM API KEY for MultiScrobbler|
    |multiscrobbler_lastfm_secret|M|The LastFM API secret for MultiScrobbler|
    |listenbrainz_token|M|The ListenBrainz token|
    |listenbraniz_username|M|The ListenBrainz username|
    |koito_endpoint_url|M|The Koito endpoint URL|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/multi-scrobbler//deploy-multi-scrobbler.yaml --no-check
```

## Commands

## Notable comments
