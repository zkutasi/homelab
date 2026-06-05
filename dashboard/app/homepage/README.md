# Homepage

[Homepage](https://gethomepage.dev/) - A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations.

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
./common-ansible-run-playbook.sh --playbook dashboard/app/homepage/deploy-homepage.yaml --no-check
```

## Commands

## Notable comments
