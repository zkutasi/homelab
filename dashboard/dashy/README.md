# Dashy

[Dashy](https://dashy.to/) - A self-hostable personal dashboard built for you. Includes status-checking, widgets, themes, icon packs, a UI editor and tons more!

## The setup

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

```bash
./common-ansible-run-playbook.sh --playbook dashboard/dashy/deploy-dashy.yaml --no-check
```

## Commands

## Notable comments

- Widgets here are not tied into the card themselves, but they are bigger and can sit in any group section or on their own group.
- PiHole widget for v6 API does not work, as it should not use an API key but a new mechanism not yet implemented.
- Any widget requires some metrics uses Glances at the backend... if you already use Glances, great, but if not or use something else, it is not going to work.
