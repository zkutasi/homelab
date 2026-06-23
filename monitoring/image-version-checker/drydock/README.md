# DryDock

[DryDock](https://drydock.codeswhat.com/) - Open source container update monitoring — 22 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metrics, and a modern dashboard.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/drydock/central/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
