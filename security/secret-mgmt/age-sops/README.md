# SOPS & age

[SOPS](https://github.com/getsops/sops) and [age](https://github.com/FiloSottile/age) are tools to be used to protect secrets but still able to commit them in git repos for example so version-controlling them too.

## The setup

The Host that is used to handle the git repo has SOPS and age installed.

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook security/age-sops/deploy-age.yaml --no-check
    ./common-ansible-run-playbook.sh --playbook security/age-sops/deploy-sops.yaml --no-check
    ```

### Post deployment

1. Configure age to generate keys

    ```bash
    ./common-ansible-run-playbook.sh --playbook security/age-sops/configure-age.yaml --no-check
    ```

## Commands

To encrypt or decrypt, use the helper script `sops.sh`

## Notable comments

- One can use the provided `sops.sh` script to encrypt and decrypt files with SOPS.
- Even a git pre-commit hook was added to protect in the case of not properly updating the encrypted (& committed) files.
