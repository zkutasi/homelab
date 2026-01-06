# Linkding

[Linkding](https://linkding.link/) - A self-hosted bookmark manager designed to be minimal, fast, and easy to set up. Tag manually, import/export. Browser extension to add, REST API and RSS feed support.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/linkding/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

4. Create a superuser account

    ```bash
    kubectl -n linkding exec -ti deployment/linkding -- python manage.py createsuperuser --username=XXX --email=XXX
    ```

## Commands

## Notable comments
