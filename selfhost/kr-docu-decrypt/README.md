# KR Document decryptor

This is a very personal service, able to decrypt KR documents sent by the Hungarian Government, using [the official site](https://e-kerelem.mvh.allamkincstar.gov.hu/enter/krnyomtatas/krNyomtatas.xhtml)

- ~~Official site~~
- ~~Source repository~~
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

The service consists of a Selenium docker container, running Chrome. An additional python container hosts the application controlling Selenium, what to do, where to click and publishes a REST API to accept XML files. The XML files get uploaded into the KR government site and the decrypted PDF is saved in the REST API response.

An idea how to use it: Create a Google App Script to catch such emails, extract the XML and send to decryption automatically. Then the resulting PDF file can be emailed to the recipient. Be sure to label the processed emails as such to avoid continuously decrypting the same XML.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |port_kr_docu_decrypt|M|The host port of the KR Docu Decrypt web UI|
    |port_selenium|M|The port of the bundled Selenium WebDriver|
    |port_selenium_vnc|M|The port of the bundled Selenium VNC viewer|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook selfhost/kr-docu-decrypt/deploy-kr-docu-decrypt.yaml --no-check
    ```

### Post deployment

1. Prepare a Google App script to handle the emails with the encrypted XML automatically.

## Metrics, Alerts, Notifications

## Commands

## Notable comments
