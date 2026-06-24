# Karakeep

[Karakeep](https://karakeep.app/) - A self-hostable bookmark-everything app (links, notes and images) with AI-based automatic tagging and full text search.

## The setup

## Prerequisites

- For Searching, MeiliSearch is required as a separate container.
- For proper web-crawling, a Chrome container is also required (for example to accept the EU cookie consents)
- For AI tagging, Ollama or a public AI API is required.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |karakeep_nextauth_secret|M||

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate configuration from the Ansible inventory

    ```bash
    ./common-ansible-run-playbook.sh --playbook bookmarks/karakeep/generate-configuration.yaml --no-check
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Commands

## Notable comments
