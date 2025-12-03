# Semaphore UI

[Semaphore UI](https://semaphoreui.com/) is a GUI for automating Ansible, Terraform, OpenTofu and even scripts in Bash & Python.

## The setup

The homelab has a bunch of Ansible playbooks. Some of them require scheduled execution, like the SW updates.

## Prerequisites

- A git repo that has the automations in it
- A way the inventory can be injected
  - In the same (public) git repo protected with Ansible Vault
  - In a separate private git repo (preferred)

## Usage

### Deploy the app

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

On the GUI, set up the required things: Repositories, Inventories, Task Templates, etc....

## Commands

## Notable comments

- In the world of automation, SemaphoreUI seems a bit limiting: cannot execute commands in their own custom docker container, and I could not solve the secret handling with SOPS only as I could not chain together a pipeline with one Script Task and one Ansible Task. Not to mention the SOPS binary is nowhere to be found in Semaphore's environment.
- Certain things are only for certain kinds of Tasks: Vaults can only be passed to Ansible type of tasks for example
- Ansible Vault is highly recommended, as Semaphore UI closely integrates into Vault and is able to use the decryption facilities. No extra commands or dependencies required. Otherwise it is pretty hard to provide the inventory from the git repo itself.
