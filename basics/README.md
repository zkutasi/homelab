# Basic linux setup of the hosts

This folder contains fundamental settings applied to hosts, including

- `docker/setup-docker.yaml` - Set up Docker and Docker Compose on the hosts
- `git/setup-git.yaml` - Set up git and some common best practices
- `hardware/` - Hardware related settings, like alerts
- `scripts/setup-scripts.yaml` - Some hosts have developed bash scripts. Distribute them.
- `setup-bashrc.yaml` - Set up the shell environment of the login user
- `setup-dns.yaml` - Make the hosts resolve the local network domain through the home DNS servers
- `setup-fastfetch.yaml` - Install fastfetch, a system information tool
- `setup-fstab.yaml` - Mount the network shares the hosts need
- `setup-hosts.yaml` - Add static name resolution for the services some hosts need to reach without relying on the home DNS
- `setup-locale.yaml` - Install the locales
- `setup-mail.yaml` - Enable sending emails from the hosts that need it
- `setup-notifications.yaml` - Enable sending push notifications from the hosts
- `setup-ntp.yaml` - Set up the timezone for all of the hosts and enable automatic time sync
- `setup-packages.yaml` - Install some basic useful packages everywhere
- `setup-python.yaml` - Set up the python environment on each host
- `setup-snmp.yaml` - Set up SNMP for monitoring
- `setup-ssh.yaml` - Set up an SSH key pair for the login user
- `setup-starship.yaml` - Set up the [starship](https://starship.rs/) command prompt module
- `setup-sudoers.yaml` - Allow some commands to run with sudo but without password
- `setup-sysctl.yaml` - Raise the system resource limits where the default ones are too low
- `setup-vim.yaml` - Install & configure vim with defaults

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_mailrise|M|The port of the Mailrise SMTP server|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |fstab_entries|O|A list of network shares to mount on the host|
    |fstab_entries.src|M|The source of the share (e.g. `nas.home:/export/media`)|
    |fstab_entries.path|M|The local mount point|
    |fstab_entries.fstype|O|The filesystem type. Default is nfs|
    |fstab_entries.opts|O|The mount options. Default is a set of NFS options that wait for the network and do not block the boot|
