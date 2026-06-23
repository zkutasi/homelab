# External DNS

[External DNS](https://github.com/kubernetes-sigs/external-dns) is a convenience tool to register the given FQDN-IP pairs into a DNS Service automatically and keep them up-to-date.

## The setup

Whenever there is a HTTPProxy Contour ingress is deployed, the system checks which FQDN-IP mapping has to be shipped into the DNS Server and when applicable, does it. There is a PiHole configured in there as local DNS Server.

## Prerequisites

- Ingress (Contour) installed
- Local DNS Server (PiHole) is installed

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo external-dns -l
    ```

3. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook kubernetes/infrastructure/external-access/external-dns/generate-configuration.yaml --no-check
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
