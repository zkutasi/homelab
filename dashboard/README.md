# Dashboards

Dashboards give a UI over the homelab: a start page for the Apps, a Kubernetes cluster manager, and Linux host administration.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- App dashboards - Start pages linking to the Apps, with their health and App-specific info
- Kubernetes dashboards - Manage Kubernetes clusters from a UI instead of the CLI
- Linux dashboards - Administer Linux hosts from a web UI

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
