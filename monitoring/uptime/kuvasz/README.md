# Kuvasz

[Kuvasz](https://kuvasz-uptime.dev/) - An open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |kuvasz_admin_username|M||
    |kuvasz_admin_password|M||
    |kuvasz_admin_apikey|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Using the ansible inventory, generate the config by running the following command

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/uptime/kuvasz/central/generate-configuration.yaml --no-check
    ```

2. To check against the custom certs you might have it is a must to mount them. For this, follow these instructions:

    1. Get the `cacerts` from the image as instructed in the documentation

        ```bash
        docker run --rm \
            --entrypoint cat \
            eclipse-temurin:25-jre-alpine-3.23 \
            /opt/java/openjdk/lib/security/cacerts > cacerts
        ```

    2. Add your CA into this

        ```bash
        CA_DIR=$(git rev-parse --show-toplevel)/security/certificates/certs/
        docker run --rm \
            -v ${CA_DIR}:/tmp/certs/ca.crt \
            -v ${PWD}/cacerts:/tmp/certs/cacerts \
            eclipse-temurin:25-jre-alpine-3.23 \
            sh -c 'cd /tmp/certs && keytool \
                -keystore cacerts \
                -storepass changeit \
                -noprompt \
                -trustcacerts \
                -importcert \
                -alias homelab-ca \
                -file ca.crt'
        ```

    3. Now add this new `cacerts` file as an extra Secret mount to the container. This is done in the deploy.sh script.

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments

- No ICMP or DNS test yet, just HTTP, but that one is highly configurable
- Configurable via Code as well, in this case some parts of the UI become read-only
- For me the custom CA setup did not work, though there were everything required for the mapping of the CA in the Pod.
