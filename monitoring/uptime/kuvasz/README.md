# Kuvasz

Kuvasz (pronounce as [ˈkuvɒs]) is an open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!

- [Official site](https://kuvasz-uptime.dev/)
- [Source repository](https://github.com/kuvasz-uptime/kuvasz)
- [Documentation](https://kuvasz-uptime.dev/)
- [Image repo](https://hub.docker.com/r/kuvaszmonitoring/kuvasz)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |kuvasz_admin_username|M|The admin username|
    |kuvasz_admin_password|M|The admin password|
    |kuvasz_admin_apikey|M|A randomly generated API key for the admin user|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

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
        CA_DIR=$(git rev-parse --show-toplevel)/security/certificates/certs
        docker run --rm \
            -v ${CA_DIR}/ca.crt:/tmp/certs/ca.crt \
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

    3. Now add this new `cacerts` file as an extra Secret mount to the container: place it at `config/static/cacerts`, and the deploy-k8s.sh script mounts it.

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- No ICMP or DNS test yet, just HTTP, but that one is highly configurable
- Configurable via Code as well, in this case some parts of the UI become read-only
- For me the custom CA setup did not work, though there were everything required for the mapping of the CA in the Pod.
