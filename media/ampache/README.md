# Ampache

[Ampache](https://ampache.org/) - A web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device. Able to extract correct metadata from embedded tags in your files and/or the file name.

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
./common-ansible-run-playbook.sh --playbook media/ampache/deploy-ampache.yaml --no-check
```

## Commands

## Notable comments
