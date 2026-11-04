# HDSentinel

Hard Disk Sentinel (HDSentinel) is a multi-OS SSD and HDD monitoring and analysis software. Its goal is to find, test, diagnose and repair hard disk drive problems, report and display SSD and HDD health, performance degradations and failures.

- [Official site](https://www.hdsentinel.com/)
- ~~Source repository~~
- [Documentation](https://www.hdsentinel.com/help/en/)
- ~~Image repo~~
- [Other sites](https://www.hdsentinel.com/hard_disk_sentinel_linux.php)

## The setup

The Linux console version runs daily via cron on the hosts that handle disks and writes an HTML health report. These report files are shared via the network. Then the main HDSentinel UI app shall reach these shares and read those files.

## Prerequisites

1. Download the Linux console version of HDSentinel, and place the `HDSentinel` binary into `hdsentinel_dir` on each host

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |hdsentinel_dir|M|The folder holding the HDSentinel binary and its HTML report|
    |network_subnet|M|The network subnet that defines all of the machines' IP addresses, CIDR notation|

### Deploy the app

1. Configure with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook monitoring/hardware/HDSentinel/configure-hdsentinel.yaml --no-check
    ```

## Notable comments
