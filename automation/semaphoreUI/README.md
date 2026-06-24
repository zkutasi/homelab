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

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |semaphore_username|M||
    |semaphore_password|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook automation/semaphoreUI/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

On the GUI, set up the required things: Repositories, Inventories, Task Templates, etc....

## Commands

## Notable comments

- In the world of automation, SemaphoreUI seems a bit limiting: cannot execute commands in their own custom docker container, and I could not solve the secret handling with SOPS only as I could not chain together a pipeline with one Script Task and one Ansible Task. Not to mention the SOPS binary is nowhere to be found in Semaphore's environment.
- Certain things are only for certain kinds of Tasks: Vaults can only be passed to Ansible type of tasks for example
- Ansible Vault is highly recommended, as Semaphore UI closely integrates into Vault and is able to use the decryption facilities. No extra commands or dependencies required. Otherwise it is pretty hard to provide the inventory from the git repo itself.
