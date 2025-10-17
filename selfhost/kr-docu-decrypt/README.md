# KR Document decryptor

This is a very personal service, able to decrypt KR documents sent by the Hungarian Government, using [the official site](https://e-kerelem.mvh.allamkincstar.gov.hu/enter/krnyomtatas/krNyomtatas.xhtml)

## The setup

The service consists of a Selenium docker container, running Chrome. An additional python container hosts the application controlling Selenium, what to do, where to click and publishes a REST API to accept XML files. The XML files get uploaded into the KR government site and the decrypted PDF is saved in the REST API response.

An idea how to use it: Create a Google App Script to catch such emails, extract the XML and send to decryption automatically. Then the resulting PDF file can be emailed to the recipient. Be sure to label the processed emails as such to avoid continuously decrypting the same XML.

## Prerequisites

None.

## Ansible inventory setup

No special setup is required.

## Usage

1. Deploy the service

    ```bash
    ./common-ansible-run-playbook.sh --playbook selfhosting/kr-docu-decrypt/deploy-kr-docu-decrypt.yaml --no-check
    ```

2. Prepare a Google App script to handle the emails with the encrypted XML automatically.

## Commands

## Notable comments
