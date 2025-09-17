# Git

[Git](https://git-scm.com/) is the most popular source/version controlling software of our time.

## The setup

The control server hosts the git repo and work is done through a remote VSCode instance using the SSH plugin.

All the homelab code is done in Infrastructure-as-Code (IaC) fashion: Ansible, Terraform and other automation tools are used, configuration is split into public (versioning, useful settings, env variables) and private (passwords, keys, inventories). Everything private goes through [SOPS](https://github.com/getsops/sops) via [age](https://github.com/FiloSottile/age) encryption to also keep all the pieces in the same git repo and facilitate gitOps later on.

There are a handful of useful stuff set up:

- Some shortened aliases
- Some pre-commit hooks ([Check for more](https://pre-commit.com/hooks.html)):
  - [Common ones](https://github.com/pre-commit/pre-commit-hooks) - Like trailing whitespaces, newline at end of file, etc...
  - [YAMLLint](https://github.com/adrienverge/yamllint)- Since most of the config is YAML, might as well lint them
  - [Typos](https://github.com/crate-ci/typos) - Accidental typos happen, avoid them even in code
  - [CodeSpell](https://github.com/codespell-project/codespell) - Another one for typos and spelling
  - [MarkdownLint](https://github.com/DavidAnson/markdownlint-cli2) - Lints those md files too. This one seems more up-to-date.
  - [GitLeaks](https://github.com/gitleaks/gitleaks) - For avoiding to commit secrets in plaintext

## Prerequisites

## Ansible inventory setup

N/A

## Usage

## Commands

## Notable comments
