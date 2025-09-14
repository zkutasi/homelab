# Semaphore UI

[Semaphore UI](https://semaphoreui.com/) is a GUI for automating Ansible, Terraform, OpenTofu and even scripts in Bash & Python.

## The setup

The homelab has a bunch of Ansible playbooks. Some of them require scheduled execution, like the SW updates.

## Prerequisites

## Usage

1. Add the helm repository

    ```bash
    helm repo add semaphoreui https://semaphoreui.github.io/charts
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo semaphoreui/semaphore -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
