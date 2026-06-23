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

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add seaweedfs XXX
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo seaweedfs/seaweedfs -l
    ```

3. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook storage/s3/seaweedfs/generate-configuration.yaml --no-check
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
