# Basic linux setup of the hosts

This folder contains fundamental settings applied to hosts, including

- `docker/setup-docker.yaml` - Set up docker on the hosts, pay special attention to Synology, where the docker compose version should be uplifted as well
- `git/setup-git` - Set up git and some common best practices
- `setup-bashrc.yaml` - Set up bashrc with some common defaults
- `setup-dns.yaml` - Set up the home DNS server and the local .home domain
- `setup-fstab.yaml` - Set up the mount points to mount NFS shares around the home network
- `setup-hosts.yaml` - Set up the /etc/hosts file to have home-routable DNS entries, until the PiHole instance is spread by the DHCP server
- `setup-ntp.yaml` - Set up the timezone for all of the hosts and enable automatic time sync
- `setup-packages.yaml` - Install some basic useful packages everywhere
- `setup-pushover.yaml` - Set up push-notifications via Pushover
- `setup-python.yaml` - Set up the python environment on each host
- `setup-scripts.yaml` - Some hosts have developed bash scripts. Distribute them.
- `setup-snmp` - Set up SNMP on each host for monitoring
- `setup-ssh.yaml` - Set up on each host a public-private SSH key for the default (hopefully non-root) user
- `setup-starship.yaml` - Set up the [starship](https://starship.rs/) command prompt module
- `setup-sudoers.yaml` - Allow some commands to run with sudo
- `setup-sysctl.yaml` - Set some kernel parameters
- `setup-vim.yaml` - Install & configure vim with defaults
