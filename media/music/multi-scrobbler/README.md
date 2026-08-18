# Multi-Scrobbler

Scrobble plays from multiple sources to multiple clients

- [Official site](https://docs.multi-scrobbler.app/)
- [Source repository](https://github.com/foxxmd/multi-scrobbler)
- [Documentation](https://docs.multi-scrobbler.app/)
- [Image repo](https://hub.docker.com/r/foxxmd/multi-scrobbler)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |multiscrobbler_baseurl|M|The Callback URL used by interactive login sites|
    |multiscrobbler_lastfm_api_key|M|The LastFM API KEY for MultiScrobbler|
    |multiscrobbler_lastfm_secret|M|The LastFM API secret for MultiScrobbler|
    |listenbrainz_token|M|The ListenBrainz token|
    |listenbraniz_username|M|The ListenBrainz username|
    |koito_endpoint_url|M|The Koito endpoint URL|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/music/multi-scrobbler//deploy-multi-scrobbler.yaml --no-check
```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
