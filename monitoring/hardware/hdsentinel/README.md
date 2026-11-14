# HDSentinel

Hard Disk Sentinel (HDSentinel) is a multi-OS SSD and HDD monitoring and analysis software. Its goal is to find, test, diagnose and repair hard disk drive problems, report and display SSD and HDD health, performance degradations and failures.

- [Official site](https://www.hdsentinel.com/)
- ~~Source repository~~
- [Documentation](https://www.hdsentinel.com/help/en/)
- ~~Image repo~~
- [Other sites](https://www.hdsentinel.com/hard_disk_sentinel_linux.php)

## The setup

The Linux console version runs daily via cron on the hosts that handle disks and writes an HTML health report. These report files are shared via the network. Then the main HDSentinel UI app shall reach these shares and read those files.

The deploy playbook downloads the pinned version of the Linux console build from the official site and installs the binary into `hdsentinel_dir` on each host.

## Prerequisites

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |hdsentinel_dir|M|The folder holding the HDSentinel binary and its HTML report|

### Deploy the app

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/hardware/hdsentinel/deploy-hdsentinel.yaml --no-check
    ```

2. Configure with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/hardware/hdsentinel/configure-hdsentinel.yaml --no-check
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- HDSentinel is released neither on GitHub nor in any registry, so Renovate can't see its version. Check the Linux page under "Other sites" for a newer build, and bump `requested_binary_version` in `deploy-hdsentinel.yaml` by hand.
