# Docker

Docker is an open platform for developing, shipping, and running applications.

- [Official site](https://www.docker.com/)
- [Source repository](https://github.com/moby/moby)
- [Documentation](https://docs.docker.com/)
- ~~Image repo~~
- ~~Other sites~~

## The setup

Docker is installed on every host in the `docker` group. The daemon is configured via `daemon.json`:

- IPv6 enabled
- Fixed address pools
- Log rotation (5x 10MB, compressed)
- Live-restore
- Prometheus metrics endpoint.

On Synology, Docker comes from DSM; only Docker Compose is uplifted and sudoless usage is set up.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set (a common default can also go into `group_vars/all`)

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |docker_cli_path|M|The path of the docker CLI on the host (e.g. `/usr/bin/docker`; elsewhere on Synology devices, where it is not on the PATH)|
    |docker_compose_files_group|O|The group (name or GID) of the folders and files created for Docker apps on the host. Default is the Ansible user's name|
    |docker_compose_files_owner|O|The owner (user name or UID) of the folders and files created for Docker apps on the host. Default is the Ansible user|
    |docker_data_root|O|The folder where docker stores its data. Default is /var/lib/docker (`/volume1/@docker` on Synology devices)|
    |docker_docker_group_id|M|The group ID (GID) of the `docker` group on the host, see `getent group docker`|
    |docker_ipv6_ula_subnet|M|The IPv6 ULA subnet for the default docker bridge network (e.g. `fd00:dead:beef::/48`)|
    |docker_is_slave_mount_allowed|O|Whether the host allows mounting `/` into containers with slave propagation (`rslave`). Default is true; set it to false on hosts that do not support it (e.g. Synology devices)|
    |docker_with_sudo|M|Whether docker requires sudo to be executed (`false` once sudoless docker is set up)|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook basics/docker/setup-docker.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook basics/docker/generate-configuration.yaml --no-check
    ```

2. Deploy the Prometheus configs locally

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

- Start all docker compose stacks on all docker hosts (for example after a reboot or an outage)

    ```bash
    ./common-ansible-run-playbook.sh --playbook basics/docker/start-all-compose-stacks.yaml --no-check
    ```

## Notable comments
