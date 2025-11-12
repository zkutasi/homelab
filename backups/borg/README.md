# Borg, Borgmatic, Borwarehouse

[Borg](https://www.borgbackup.org/) is a Linux backup tool one can use to backup individual folders, encrypt, deduplicate and manage.

[Borgmatic](https://torsion.org/borgmatic/) is a wrapper around Borg to provide a better, YAML-based configuration format to help prevent the excessive usage of the Borg CLI.

[Borgwarehouse](https://borgwarehouse.com/) is an aggregator WebUI for those who use Borg on various hosts, to have a unified view.

## The setup

I really wanted a unified UI, so I have placed Borgwarehouse on the backupServer host, in a docker container. Borgwarehouse also contains the Borg server in it, so that part is done.

Then all client hosts need a Borgmatic docker container as well, even the backup server too. The Borgmatic container will also contain Borg itself. All clients will back up to the remote backupServer only, not locally.

This set of ansible playbooks will set everything up.

## Prerequisites

If you have a Synology and the backup server is going to be there, these items have to be performed manually on the Synology DSM UI beforehand:

- Required Packages
  - Docker
  - SynoCli Network Tools (ssh-keyscan tool)
- Create a backup volume, created to host all backups.
- Create a backup user group, access granted to the backup. volume. This is required to provide adequate permissions to both the backup group users (the Synology admin and the borgwarehouse user in the containers). A specific GID cannot be created on Synology, but in my case the DSM UI created the GID of `65537`.

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |borgwarehouse_cronjob_key|M|A Secret key generated via `openssl rand -base64 32` for example|
    |port_borgwarehouse_ssh|M|The SSH port the borg server will listen on on the backupServer host|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |borgwarehouse_alert|O|The amount of minutes borgwarehouse shall alert after the last backup. Default is 604800 (7 days).|
    |borgwarehouse_storage_size|O| The size of the storage quota. Default is 10 GB.|
    |borgmatic_encryption_passphrase|M|The encryption passphrase|

3. For the `backupserver` group set up the following variables:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |backups_gid|M|The Group ID Synology created for the backup group|

### Deploy the app

First, deploy Borgwarehouse, because we need to create an API token for the REST API usage on the GUI

```bash
./common-ansible-run-playbook.sh --playbook backups/borg/borgwarehouse/deploy-borgwarehouse.yaml --no-check
```

This will do the following

1. Deploy borgwarehouse to the backupserver host
   1. Deploy the docker compose file, folders and start the container
   2. Edit the auto-generated sshd_conf file, and replace the SSH port from 22 to the desired one, then restart

Then go to the Borgwarehouse UI and

1. Log in with admin/admin
2. Go to the Admin page (top right corner) -> Account -> Integrations -> Generate token. Be sure to set the proper rights to the token
3. Place the generated token into your inventory (preferably in group_vars/all.yaml) as `borgwarehouse_api_key` into the `all` group_vars file

Then finish the deployment with

```bash
./common-ansible-run-playbook.sh --playbook backups/borg/setup-borg.yaml --no-check
```

1. Configure borgwarehouse
   1. Using the Borgwarehouse REST API, list all the repos and their IDs
   2. Make sure all clients have an SSH key, if not generate one (will be required for registering the repo for the client)
   3. Register in non-existing repos from the `backupclient` group
2. Deploy borgmatic to all the backupClients
   1. Gather from the borgwarehouse REST API all the repos
   2. Deploy the borgmatic docker container on all clients and template the borgmatic config properly with the info about the server and the proper repo ID
3. Configure borgmatic on all the backupClients
   1. Add the backupserver's SSH key to each client's known_host file
   2. Init the borg repo from the client side, which requires proper SSH connection to the server

## Commands

Dry-run a test backup exposing the filenames that would be backed up, tests the used filters:

```bash
docker exec -ti borgmatic borgmatic --dry-run --verbosity 2 --log-file - --files
```

Do a backup, useful to check how big a backup is:

```bash
docker exec -ti borgmatic borgmatic --verbosity 1 --stats --log-file -
```

Delete a backup (XXX is the backup's name):

```bash
docker exec -ti borgmatic borgmatic delete --archive XXX
docker exec -ti borgmatic borgmatic compact --progress
```

## Notable comments

- Borgwarehouse
  - The default port 22 for the SSH cannot work as it would require privilege. This is handled by the playbooks.
  - On Synology, there is a weird issue: SSHd will log this `Fatal glibc error: cannot get entropy for arc4random`. Which means that the built in SSHd wants to use a kernel feature not present on this particular host. The solution was to rebuild the docker image using the Bullseye version of Debian instead of the Bookworm. This rolls back the `glibc` version to one that still has the old ways of generating random numbers.
  - If IPv6 is required, one needs to set the `HOSTNAME=::` environment variable, this will bind to the IPv6 address on the NextJS UI app. This is handled by the playbooks.
- Borgmatic
  - It is mandatory to have at least 1GB of RAM on the hosts, otherwise even the repo init will be potentially OOMKilled
  - It is required for each client to have its own public key in the backupServer's `authorized_keys` and also the backupserver's host key in its own `known_hosts` file. This is handled by the playbooks
