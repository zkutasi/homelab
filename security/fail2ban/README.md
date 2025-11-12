# Fail2Ban

[Fail2Ban](github.com/fail2ban/fail2ban) is a simple brute-force protection against any exposed port. Watch auth logs and block IPs failing to authenticate properly.

## The setup

I have deployed a full stack of some tools to help me visualize the banned IPs:

- [GeoIP Updater](https://github.com/maxmind/geoipupdate) - A Tool to periodically download the latest GeoIP database from [MaxMind](https://www.maxmind.com/)
- Fail2Ban itself
- [Fail2Ban GeoExporter](https://github.com/vdcloudcraft/fail2ban-geo-exporter) - Prometheus exporter for IP GeoLocations
- [Fail2Ban Exporter](https://github.com/hctrdev/fail2ban-prometheus-exporter) - A regular exporter for basic metrics

## Prerequisites

N/A

## Usage

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook security/fail2ban/deploy-fail2ban.yaml --no-check
```

## Commands

## Notable comments

- There is a neat little Grafana dashboard and a full stack for exposing the GeoLocation of the banned IPs, see [this reddit post](https://www.reddit.com/r/selfhosted/comments/1j9w4f6/feels_good_to_know_homelab_is_one_step_safer/) for inspiration.
