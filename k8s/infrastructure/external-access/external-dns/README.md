# External DNS

[Official Site](https://github.com/kubernetes-sigs/external-dns)

## The setup

Whenever there is a HTTPProxy Contour ingress is deployed, the system checks which FQDN-IP mapping has to be shipped into the DNS Server and when applicable, does it. There is a PiHole configured in there as local DNS Server.

## Prerequisites

- Ingress (Contour) installed
- Local DNS Server (PiHole) is installed

## Usage

1. Add the helm repository

    ```bash
    helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo external-dns -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    extraArgs:
     - "--pihole-api-version=6"
     - "--pihole-server=..."
     - "--pihole-password=..."
     - "--pihole-tls-skip-verify"
    ```

4. Install with the provided script

    ```bash
    ./deploy.sh
    ```

## Commands

## Notable comments
