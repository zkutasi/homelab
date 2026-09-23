# Pdfding

Selfhosted PDF manager, viewer and editor offering a seamless user experience on multiple devices.

- [Official site](https://www.pdfding.com)
- [Source repository](https://codeberg.org/mrmn/PdfDing)
- [Documentation](https://docs.pdfding.com/)
- [Image repo](https://hub.docker.com/r/mrmn/pdfding)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pdfding_secret_key|M|A randomly generated secret|
    |pdfding_hostname|M|The App's hostname, required due to ALLOWED_HOSTS|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook toolboxes/pdfding/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
