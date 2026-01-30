# Kopia

[Kopia](https://kopia.io/) is a relative new contender, with cool features like supporting multiple hosts, has a great webUI.

## The setup

I wanted a central management webUI, so I have placed the Kopia Repository Server onto my Synology NAS.

All other client machines also will have a Kopia Server, but they will connect to this remote Repository.

All of the Servers can have a webUI, and fortunately the Repository Server's webUI shows every hosts's snapshots (these are the backups themselves) and policies (these control what do back up, skip, on what schedule and many-many more).

## Prerequisites

If you have a Synology and the backup server is going to be there, these items have to be performed manually on the Synology DSM UI beforehand:

- Required Packages
  - Docker
- Create a backup volume, created to host all backups.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |kopia_client_password|M|The password on the client side|
    |kopia_repo_password|M|The Repository password|
    |kopia_server_username|M|The Kopia central server username, also acts as the control-server username|
    |kopia_server_password|M|The above user's password|
    |port_kopia|M|The Kopia Server port any Server will listen on|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy Kopia Server and clients

```bash
./common-ansible-run-playbook.sh --playbook backups/kopia/deploy-kopia.yaml --no-check
```

This will do the following:

1. Check if the self-generated SSL certs are already there
   1. If not, deploy Kopia to generate them
   2. Wait until the certs are generated
2. Deploy Kopia on every host, properly configured

### Configure the Server and the clients

```bash
./common-ansible-run-playbook.sh --playbook backups/kopia/configure-kopia.yaml --no-check
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

Now attach into the client UIs one by one and initiate a snapshot of the folder `/sources` which maps all of the requested ones.

For Windows clients or for clients not capable to be in automations, do the following:

1. Install the client UI application manually
2. Create a user@host user in the Repository Server to be able to connect: `docker exec -ti kopia kopia server users add <username>@<host> --user-password=<password>`
3. Restart the server docker container (`docker compose down; docker compose up -d`) or reload the config (or wait 5-10 minutes)
4. Connect on the client UI to the Repository Server (using the URL, the fingerprint and the client password). Do not forget to set the same username@host that was created before.

## Commands

[Command line reference](https://kopia.io/docs/reference/command-line/common/)

## Notable comments

- Remote clients can only connect after the Server has established connection to its own filesystem
- The same ENV variable means different things in the Repository Server and on a client (like the SERVER_PASSWORD), so watch out for this
- Policy updates or any notable change require either a Server restart or a CLI server refresh
- If you ever need to migrate the server's backup-folder, here is what I have used, between two Synology devices:

    ```bash
    rsync -ahH --numeric-ids --hard-links --progress --inplace -e "ssh -p 22222" --rsync-path="/bin/rsync" /volume1/backups/kopia/ <USER>@<HOST>:/volume1/backups/kopia/
    ```
