# Navidrome

An open source web-based music collection server and streamer. It gives you freedom to listen to your music collection from any browser or mobile device. It's like your personal Spotify!

- [Official site](https://www.navidrome.org/)
- [Source repository](https://github.com/navidrome/navidrome/)
- [Documentation](https://www.navidrome.org/docs/)
- [Image repo](https://hub.docker.com/r/deluan/navidrome)
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
    |music_mounts|O|The folders to mount into the container for music|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/music/navidrome/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/music/navidrome/deploy-navidrome.yaml --no-check
    ```

## Metrics, Alerts, Notifications

1. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

2. Load in any of the matching Grafana dashboards

    - [18038](https://grafana.com/grafana/dashboards/18038-navidrome/)
    - [24397](https://grafana.com/grafana/dashboards/24397-navidrome-observability/)

## Commands

## Notable comments
