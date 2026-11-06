# PDFCraft

A free, privacy-focused PDF toolkit that runs entirely in your browser. With 90+ professional tools, you can edit, convert, merge, split, and secure your PDF files without ever uploading them to a server.

- [Official site](https://pdfcraft.devtoolcafe.com/)
- [Source repository](https://github.com/PDFCraftTool/pdfcraft)
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook toolboxes/pdfcraft/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
