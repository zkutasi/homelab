# Maintenance

Standalone Ansible playbooks for periodic upkeep, not tied to any specific deployed app.

- `cleanup.yaml` - Prunes unused Docker containers/images/networks/volumes, and removes any dangling `:latest`-tagged images, on all `docker` hosts
- `update-krew.yaml` - Upgrades `krew` and its installed `kubectl` plugins on the control host
- `update-packages.yaml` - Updates and upgrades OS packages on all self-managed Linux hosts
- `update-pipx-packages.yaml` - Updates all `pipx`-installed packages on all self-managed Linux hosts
