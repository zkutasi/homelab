# Homepage

A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations.

- [Official site](https://gethomepage.dev/)
- [Source repository](https://github.com/gethomepage/homepage)
- [Documentation](https://gethomepage.dev/configs/)
- [Image repo](https://github.com/gethomepage/homepage/pkgs/container/homepage)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |homepage_allowed_hosts|M|Comma-separated list of the host[:port] values Homepage is opened on in the browser (e.g. `192.168.1.10:3000,dashboard.example.home`)|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/homepage/deploy-homepage.yaml --no-check
    ```

### Post deployment

1. Generate the dashboard configuration, including an entry for every service exposed through the Kubernetes ingress. Re-run it whenever services are added or removed.

    ```bash
    ./common-ansible-run-playbook.sh --playbook dashboard/app/homepage/configure-homepage.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

## Notable comments
