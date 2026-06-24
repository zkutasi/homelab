# SeaweedFS

[SeaweedFS](https://example.com) - A short introduction of the app

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |seaweedfs_admin_accessKey|M||
    |seaweedfs_admin_secretKey|M||
    |seaweedfs_read_accessKey|M||
    |seaweedfs_read_secretKey|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook storage/s3/seaweedfs/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments
