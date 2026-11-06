# Cyberchef

The Cyber Swiss Army Knife - a web app for encryption, encoding, compression and data analysis

- [Official site](https://gchq.github.io/CyberChef/)
- [Source repository](https://github.com/gchq/CyberChef)
- ~~Documentation~~
- [Image repo](https://hub.docker.com/r/mpepping/cyberchef)
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

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
