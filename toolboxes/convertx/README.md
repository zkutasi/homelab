# ConvertX

[ConvertX](https://github.com/C4illin/ConvertX) is a useful set of file conversions in one package.

## The setup

Just run the image in a cluster, and access the tools in a browser.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |convertx_jwt_secret|M||

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook toolboxes/convertx/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
