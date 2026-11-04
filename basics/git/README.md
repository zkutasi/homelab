# Git

Git is the most popular source/version controlling software of our time.

- [Official site](https://git-scm.com/)
- ~~Source repository~~
- ~~Documentation~~
- ~~Image repo~~
- ~~Other sites~~

## The setup

The control server hosts the git repo and work is done through a remote VSCode instance using the SSH plugin.

All the homelab code is done in Infrastructure-as-Code (IaC) fashion: Ansible, Terraform and other automation tools are used, configuration is split into public (versioning, useful settings, env variables) and private (passwords, keys, inventories). Everything private goes through [SOPS](https://github.com/getsops/sops) via [age](https://github.com/FiloSottile/age) encryption to also keep all the pieces in the same git repo and facilitate gitOps later on.

There are a handful of useful stuff set up:

- Some shortened aliases
- Some pre-commit hooks ([Check for more](https://pre-commit.com/hooks.html)):
  - SOPS up-to-date (local) - Ensures the SOPS-encrypted secrets are in sync with their decrypted counterparts, see [age-sops](../../security/secret-mgmt/age-sops/README.md)
  - [Common ones](https://github.com/pre-commit/pre-commit-hooks) - Like trailing whitespaces, newline at end of file, etc...
  - [YAMLLint](https://github.com/adrienverge/yamllint)- Since most of the config is YAML, might as well lint them
  - [Typos](https://github.com/crate-ci/typos) - Accidental typos happen, avoid them even in code
  - [CodeSpell](https://github.com/codespell-project/codespell) - Another one for typos and spelling
  - [MarkdownLint](https://github.com/DavidAnson/markdownlint-cli2) - Lints those md files too. This one seems more up-to-date.
  - [GitLeaks](https://github.com/gitleaks/gitleaks) - For avoiding to commit secrets in plaintext
  - [BetterLeaks](https://github.com/betterleaks/betterleaks) - A more modern and flexible secret scanner

Also, if you maybe want a more modern git-hook alternative, here are a few:

- [Lefthook](https://lefthook.dev/)
- [HK](https://hk.jdx.dev/)
- [Prek](https://prek.j178.dev/)
- [Husky](https://typicode.github.io/husky/)

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |git_email|M|The email address to commit with|
    |git_name|M|The name to commit with|

### Deploy the app

1. Install and configure git on the control server with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook basics/git/setup-git.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments
