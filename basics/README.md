# Basic linux setup of the hosts

This folder contains fundamental settings applied to hosts, including

- `docker/setup-docker.yaml` - Set up docker on the hosts, pay special attention to Synology, where the docker compose version should be uplifted as well
- `git/setup-git.yaml` - Set up git and some common best practices
- `hardware/` - Hardware related settings, like alerts
- `scripts/setup-scripts.yaml` - Some hosts have developed bash scripts. Distribute them.
- `setup-bashrc.yaml` - Set up bashrc with some common defaults
- `setup-dns.yaml` - Set up the home DNS server and the local .home domain
- `setup-fastfetch.yaml` - Install fastfetch, a system information tool
- `setup-fstab.yaml` - Set up the mount points to mount NFS shares around the home network
- `setup-hosts.yaml` - Set up the /etc/hosts file to have home-routable DNS entries, until the Pi-hole instance is spread by the DHCP server
- `setup-locale.yaml` - Install and configure the locales
- `setup-mail.yaml` - Install the email packages on hosts that need to send emails (`emailnotifiers` group)
- `setup-notifications.yaml` - Set up push-notifications via Apprise (a `send_notification.sh` script on each host)
- `setup-ntp.yaml` - Set up the timezone for all of the hosts and enable automatic time sync
- `setup-packages.yaml` - Install some basic useful packages everywhere
- `setup-python.yaml` - Set up the python environment on each host
- `setup-snmp.yaml` - Set up SNMP on each host for monitoring
- `setup-ssh.yaml` - Set up on each host a public-private SSH key for the default (hopefully non-root) user
- `setup-starship.yaml` - Set up the [starship](https://starship.rs/) command prompt module
- `setup-sudoers.yaml` - Allow some commands to run with sudo but without password
- `setup-sysctl.yaml` - Set some kernel parameters
- `setup-vim.yaml` - Install & configure vim with defaults

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |fstab_entries|O|A list of network shares to mount on the host|
    |fstab_entries.src|M|The source of the share (e.g. `nas.home:/export/media`)|
    |fstab_entries.path|M|The local mount point|
    |fstab_entries.fstype|O|The filesystem type. Default is nfs|
    |fstab_entries.opts|O|The mount options. Default is a set of NFS options that wait for the network and do not block the boot|
