# Adminer

[Adminer](https://www.adminer.org/) - Database management in a single PHP file

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/adminer/tags/list | jq
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- The connection for the Database must be direct, there is no way to SSH tunnel, so the database must be accessible from remote
