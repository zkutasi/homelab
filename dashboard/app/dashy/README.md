# Dashy

A self-hostable personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more!

- [Official site](https://dashy.to/)
- [Source repository](https://github.com/lissy93/dashy)
- [Documentation](https://dashy.to/docs/)
- [Image repo](https://hub.docker.com/r/lissy93/dashy)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |pihole_apikey|M|The API key (app password) of the Primary Pi-hole instance, generated on its web UI|
    |port_dashy|M|The host port of the Dashy web UI|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/dashy/deploy-dashy.yaml --no-check
    ```

### Post deployment

1. Generate the dashboard configuration, including an entry for every service exposed through the Kubernetes ingress. Re-run it whenever services are added or removed.

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/dashy/configure-dashy.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- Widgets here are not tied into the card themselves, but they are bigger and can sit in any group section or on their own group.
- Pi-hole widget for v6 API does not work, as it should not use an API key but a new mechanism not yet implemented.
- Any widget requires some metrics uses Glances at the backend... if you already use Glances, great, but if not or use something else, it is not going to work.
