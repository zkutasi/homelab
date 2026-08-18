# External DNS

Configure external DNS servers dynamically from Kubernetes resources

- [Official site](https://kubernetes-sigs.github.io/external-dns/latest/)
- [Source repository](https://github.com/kubernetes-sigs/external-dns)
- [Documentation](https://kubernetes-sigs.github.io/external-dns/latest/)
- [Helm Chart](https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
- ~~Other sites~~

## The setup

Whenever there is a HTTPProxy Contour ingress is deployed, the system checks which FQDN-IP mapping has to be shipped into the DNS Server and when applicable, does it. There is a PiHole configured in there as local DNS Server.

## Prerequisites

- Ingress (Contour) installed
- Local DNS Server (PiHole) is installed

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook kubernetes/infrastructure/external-access/external-dns/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

1. Load in any of the matching Grafana dashboards

    - [15038](https://grafana.com/grafana/dashboards/15038-external-dns/)
    - [23969](https://grafana.com/grafana/dashboards/23969-external-dns/)

## Commands

## Notable comments
