# Kuvasz

[Kuvasz](https://kuvasz-uptime.dev/) - An open-source uptime and SSL monitoring service, with multiple notification channels, status pages, IAC support via YAML, Prometheus integration, a complete REST API and many more!

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    auth:
      enabled: true
      adminUser: ...
      adminPassword: ...
      adminApiKey: ...
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

#### Mount custom CA cert

To check against the custom certs you might have it is a must to mount them. For this, follow these instructions:

1. Get the `cacerts` from the image as instructed in the documentation

    ```bash
    docker run --rm \
        --entrypoint cat \
        eclipse-temurin:25-jre-alpine-3.23 \
        /opt/java/openjdk/lib/security/cacerts > cacerts
    ```

2. Add your CA into this

    ```bash
    docker run --rm \
        -v $(readlink -f ca.crt):/tmp/certs/ca.crt \
        -v $(pwd)/cacerts:/tmp/certs/cacerts \
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

## Commands

## Notable comments

- No ICMP or DNS test yet, just HTTP, but that one is highly configurable
- For me the custom CA setup did not work, though there were everything required for the mapping of the CA in the Pod.
