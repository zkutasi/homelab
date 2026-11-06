# OS updates

The ability to observe the required updates on a host OS, whether restart is required to activate a new kernel, or even execute those updates (though an automated Ansible playbook is better for that).

## Requirements

- Free and Open source, preferably 0$ cost
- Ability to only observe and not execute updates

## Contenders

- [PatchMon](https://patchmon.net/) - Linux Patch Management & Automation Platform
- [Linux Update Dashboard](https://github.com/TheDuffman85/linux-update-dashboard) - A self-hosted web app for managing Linux package updates across multiple servers. Connect via SSH, check for updates, and apply them from a single dashboard in your browser.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
