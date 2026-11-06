# Homepage

A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations.

- [Official site](https://gethomepage.dev/)
- [Source repository](https://github.com/gethomepage/homepage)
- [Documentation](https://gethomepage.dev/configs/)
- [Image repo](https://github.com/gethomepage/homepage/pkgs/container/homepage)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |homepage_emby_apikey|O|An Emby API key for the dashboard widget, generated on Emby. If not set, the widget is not shown|
    |homepage_allowed_hosts|M|Comma-separated list of the host[:port] values Homepage is opened on in the browser (e.g. `192.168.1.10:3000,dashboard.example.home`)|
    |grimmory_password|O|The password of that Grimmory user. If not set, the widget is not shown|
    |grimmory_username|O|A Grimmory web UI username for the dashboard widget. If not set, the widget is not shown|
    |homepage_jellyfin_apikey|O|A Jellyfin API key for the dashboard widget, generated on Jellyfin. If not set, the widget is not shown|
    |immich_api_key|O|API key for external apps to access Immich. If not set, the widget is not shown|
    |kopia_server_password|O|The above user's password. If not set, the widget is not shown|
    |kopia_server_username|O|The Kopia central server username, also acts as the control-server username. If not set, the widget is not shown|
    |netalertx_api_token|O|API token for interacting with the service from other Apps. If not set, the widget is not shown|
    |omv_password|O|The password of an OMV web UI user, for API access. If not set, the widget is not shown|
    |omv_username|O|The username of an OMV web UI user, for API access. If not set, the widget is not shown|
    |pihole_apikey|O|The API key (app password) of the Primary Pi-hole instance, generated on its web UI. If not set, the widget is not shown|
    |plex_token|O|The Plex authentication token (X-Plex-Token) of the server. If not set, the widget is not shown|
    |speedtest_tracker_api_key|O|An API token generated on the Speedtest Tracker UI. If not set, the widget is not shown|
    |urbackup_password|O|The password of that UrBackup Server user. If not set, the widget is not shown|
    |urbackup_username|O|A UrBackup Server web UI username. If not set, the widget is not shown|
    |port_homepage|M|The host port of the Homepage web UI|
    |port_pihole_webui_https|O|The host port of the Pi-hole web UI over HTTPS, needed together with `pihole_apikey`|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |qbittorrent_password|O|The qBittorrent WebUI password. If not set, the widget is not shown|
    |qbittorrent_username|O|The qBittorrent WebUI username. If not set, the widget is not shown|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/homepage/deploy-homepage.yaml --no-check
    ```

### Post deployment

1. Generate the dashboard configuration, including an entry for every service exposed through the Kubernetes ingress. Re-run it whenever services are added or removed.

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/homepage/configure-homepage.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
