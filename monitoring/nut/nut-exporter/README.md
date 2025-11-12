# NUT Exporter

[NUT Exporter](https://github.com/DRuggeri/nut_exporter) is a Prometheus compatible NUT metrics exporter.

## The setup

N/A

## Prerequisites

- A NUT Server is up and running

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |nut_server_hostname|M|The NUT Server to scrape info from|
    |nut_server_username|M||
    |nut_server_password|M||

### Deploy the app

Deploy with:

```bash
./common-ansible-run-playbook.sh --playbook monitoring/nut/nut-exporter/deploy-nut-exporter.yaml --no-check
```

## Notable comments

- I have chosen `network_mode=host`, because otherwise I would need to give a very specific IP address to the Synology NUT Server as allowed remote hosts.
