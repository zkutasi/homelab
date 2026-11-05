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

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |docker_ipv6_ula_subnet|M|The IPv6 ULA subnet for the default docker bridge network (e.g. `fd00:dead:beef::/48`)|
    |docker_data_root|O|The folder where docker stores its data. Default is /var/lib/docker|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook basics/docker/setup-docker.yaml --no-check
    ```

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
