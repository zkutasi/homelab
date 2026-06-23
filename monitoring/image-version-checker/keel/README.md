# Keel

[Keel](https://keel.sh/) - Kubernetes Operator to automate Helm, DaemonSet, StatefulSet & Deployment updates

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |keel_username|M||
    |keel_password|M||

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add keel https://keel-hq.github.io/keel/
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo keel/keel -l
    ```

3. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/keel/generate-configuration.yaml --no-check
    ```

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- Lacks a dark mode on the Dashboard.
- It is more like for self-built images, as all the different kinds of webhook triggers are only possible for those. Polling also works though for community images.
- Requires that every tracked Workload gets annotated with specific `keel.sh` annotations that control the tool (policy, trigger, approvals, etc...).
- It is quite cool, that manual approvals can also be set. So if one never approves anything, then this tool can Check only. Approvals can be done on the UI as well.
