# SOPS & age

[SOPS](https://github.com/getsops/sops) and [age](https://github.com/FiloSottile/age) are tools to be used to protect secrets but still able to commit them in git repos for example so version-controlling them too.

## The setup

The Host that is used to handle the git repo has SOPS and age installed.

## Prerequisites

N/A

## Ansible inventory setup

N/A

## Usage

1. Install the tools first

    ```bash
    ./common-run-playbook.sh --playbook security/age-sops/deploy-age.yaml --no-check
    ./common-run-playbook.sh --playbook security/age-sops/deploy-sops.yaml --no-check
    ```

2. Configure age to generate keys

    ```bash
    ./common-run-playbook.sh --playbook security/age-sops/configure-age.yaml --no-check
    ```

## Notable comments
