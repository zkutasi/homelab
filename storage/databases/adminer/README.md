# Adminer

Database management in a single PHP file

- [Official site](https://www.adminer.org/)
- [Source repository](https://github.com/TimWolla/docker-adminer)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/_/adminer)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- The connection for the Database must be direct, there is no way to SSH tunnel, so the database must be accessible from remote
