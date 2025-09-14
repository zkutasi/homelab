# Cloud Native PostgreSQL (CNPG)

[Cloud Native PostgreSQL](https://cloudnative-pg.io/) is a Kubernetes native way to run PSQL instances.

## The setup

A lot of services require some form of Database, 80% of them are fine with PostgreSQL. the 10% of the time a MariaDB is required, there is a wrapper for CNPG for that. The rest requires maybe its own flavor.

This is only the CNPG operator. For each service, that requires a Database, a separate Postgres instance will be created in those sections.

## Prerequisites

N/A

## Usage

1. Add the helm repository

    ```bash
    helm repo add cnpg https://cloudnative-pg.github.io/charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo cnpg/cloudnative-pg -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
