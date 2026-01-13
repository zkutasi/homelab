# Keel

[Keel](https://keel.sh/) - Kubernetes Operator to automate Helm, DaemonSet, StatefulSet & Deployment updates

## The setup

## Prerequisites

## Usage

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

3. Create a values yaml file for potential private data named `app-values-private.yaml`

    ```yaml
    basicauth:
        enabled: true
        user: "<USER>"
        password: "<PASSWORD>"
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
