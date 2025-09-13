# Basic linux setup of the hosts

This folder contains fundamental settings applied to hosts, including

- `setup-fstab.yaml` - Set up the mount points to mount NFS shares around the home network
- `setup-docker.yaml` - Set up docker on the hosts, pay special attention to Synology, where the docker compose version should be uplifted as well
- `setup-hosts.yaml` - Set up the /etc/hosts file to have home-routable DNS entries, until the PiHole instance is spread by the DHCP server
- `setup-ntp.yaml` - Set up the timezone for all of the hosts and enable automatic time sync
- `setup-packages.yaml` - Install some basic useful packages everywhere
- `setup-pushover.yaml` - Set up push-notifications via Pushover
- `setup-scripts.yaml` - Some hosts have developed bash scripts. Distribute them.
- `setup-ssh.yaml` - Set up on each host a public-private SSH key for the default (hopefully non-root) user
- `setup-vim.yaml` - Configure vim with defaults
