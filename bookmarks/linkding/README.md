# Linkding

[Linkding](https://linkding.link/) - A self-hosted bookmark manager designed to be minimal, fast, and easy to set up. Tag manually, import/export. Browser extension to add, REST API and RSS feed support.

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

1. Create a superuser account

    ```bash
    kubectl -n linkding exec -ti deployment/linkding -- python manage.py createsuperuser --username=XXX --email=XXX
    ```

## Commands

## Notable comments
