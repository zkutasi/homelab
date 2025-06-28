# Kopia

[Kopia](https://kopia.io/) is a relative new contender, with cool features like supporting multiple hosts, has a great webUI.

## The setup

I wanted a central management webUI, so I have placed the Kopia Repository Server onto my Synology NAS.

All other client machines also will have a Kopia Server, but they will connect to this remote Repository.

All of the Servers can have a webUI, and fortunately the Repository Server's webUI shows every hosts's snapshots (these are the backups themselves) and policies (these control what do back up, skip, on shat schedule and many-many more).

## Prerequisites

If you have a Synology and the backup server is going to be there, these items have to be performed manually on the Synology DSM UI beforehand:

- Required Packages
  - Docker
- Create a backup volume, created to host all backups.

## Ansible inventory setup

1. Create a group called `backupserver`, and include your host to act as a backup server, hosting the backups and the borgwarehouse UI
2. Create a group called `backupclient` and list all the hosts you want to take backup from, these will host borgmatic
3. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |kopia_client_password|M|The password on the client side|
    |kopia_repo_password|M|The Repository password|
    |kopia_server_username|M|The Kopia central server username, also acts as the control-server username|
    |kopia_server_password|M|The above user's password|
    |port_kopia|M|The Kopia Server port any Server will listen on|

4. Create a `backupserver` group_vars file and set up the following variables:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |backups_folder|M|The volume created on Synology to store backups in|

5. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |backupserver_hostname|M|The hostname or IP address of the backupserver from the point of client|
    |backupfolders|M|A list containing the folders to back up on the client. Each will be mounted under a single root folder that will be backed up|
    |backup_cron|O|The cron pattern when to execute the backups, default is empty, meaning nothing will be done automatically|
    |backup_exclude_patterns|O|A list of exclude_patterns, see the borgmatic manual for more info. Default is *.log.|

## Usage

First, deploy Kopia on the BackupServer, hosting the Repository and also on the client Hosts as well

```bash
./run-playbook.sh --playbook playbooks/backups/borg/deploy-kopia.yaml --no-check
```

This will do the following:

1. Check if the self-generated SSL certs are already there
   1. If not, deploy Kopia to generate them
   2. Wait until the certs are generated
2. Deploy Kopia on every host, properly configured

Then configure the Server and the clients

```bash
./run-playbook.sh --playbook playbooks/backups/borg/configure-kopia.yaml --no-check
```

This will do the following:

1. Initialize the repository server
2. Connect the Repository server to the local filesystem
3. Ensure all of the clients are granted permission (with user@hostname)
4. Acquire the server certificate fingerprint and save it for the client registration
5. Connect all of the clients with the server and its fingerprint
6. Configure Policies for each client host
   1. Register exclude patterns
   2. Register the cron schedule

## Commands

[Command line reference](https://kopia.io/docs/reference/command-line/common/)

## Notable comments

- Remote clients can only connect after the Server has established connection to its own filesystem
- The same ENV variable means different things in the Repository Server and on a client (like the SERVER_PASSWORD), so watch out for this
- Policy updates or any notable change require either a Server restart or a CLI server refresh
