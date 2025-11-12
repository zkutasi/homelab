# Nutify

[Nutify](https://github.com/DartSteven/Nutify) is an all in one solution with a NUT Server and a dashboard, with additional functionality as well.

## The setup

The UPS is plugged into one of the Synology NAS Hosts. I am using the Synology DSM built in NUT Server as it works, unlike the dockerized one (due to some USB permission issues I was unable yet to solve)

## Prerequisites

- UPS Plugged into the host

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |nutify_secret_key|M|A string to encrypt the database with|

### Deploy the app

Deploy with:

```bash
./common-ansible-run-playbook.sh --playbook monitoring/nut/nutify/deploy-nutify.yaml --no-check
```

Then go to the Web UI and complete the Setup with the Wizard.

## Notable comments

- I was unable to use the dockerized NUT Server, as for some yet unknown reason the USB device was not fully visible and I got the infamous `Can't claim USB device [XXXX:XXXX]@0/0/0: Entity not found`, although I mapped in the devices, used the cgroups and the Wizard was able to find my UPS. BUt then the config check part failed 100%. So I just use Nutify to scrape info from the Synology NUT Server, which works.
- I have chosen `network_mode=host`, because otherwise I would need to give a very specific IP address to the Synology NUT Server as allowed remote hosts.
