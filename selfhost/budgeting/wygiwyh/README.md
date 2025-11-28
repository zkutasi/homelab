# What You Get is What You Have (WYGIWYH)

[WYGIWYH](https://github.com/eitchtee/WYGIWYH)

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Add the following values into the `app-values-private.yaml` file

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |.workload.main.podSpec.containers.main.env.URL|M|The full used URL in the browser, for CSRF protection|
    |.workload.main.podSpec.containers.main.env.DJANGO_ALLOWED_HOSTS|M|The URL's hostname part|

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

3. Create the superuser account:

    ```bash
    kubectl -n wygiwyh exec -ti deployment/wygiwyh -c wygiwyh -- python manage.py createsuperuser
    ```

## Commands

## Notable comments
