# What You Get is What You Have (WYGIWYH)

[WYGIWYH](https://github.com/eitchtee/WYGIWYH) - A no-budget approach to expense tracking. Just (periodically) import your CSVs (do not forget to pre-create most things you need) and glance at the Sankey diagram.

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

4. On the UI, create some things before any Import could happen:

    1. Categories to put transactions into
    2. Currencies for the Accounts
    3. Accounts for the Transactions
    4. Rules for the Transactions
    5. Import profile for the CSV imports

## Commands

## Notable comments
