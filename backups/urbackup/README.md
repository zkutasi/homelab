# UrBackup

[UrBackup](https://www.urbackup.org/) is a Client-Server architecture backup solution, where the design clearly has built in multiühost support.

## The setup

One Server on the Synology NAS hosts the repository to back up towards, and all the clients require the client application. Both of them have docker images. According to the documentation, there are multiple ways to connect those clients: There is Auto-discovery using UDP broadcast, but that requires either host-network or docker-free installation. I found that this is not so great as even with host-networking the broadcast is not easily controllable and happens on all interfaces, if you happen to have docker on the server too you will have many interfaces there as well.

Then there is manual setup, which I have chosen as the UDP auto-discovery only would ever work in the same network domain anyway, leaving out external hosts like the VPS I have.

## Prerequisites

If you have a Synology and the backup server is going to be there, these items have to be performed manually on the Synology DSM UI beforehand:

- Required Packages
  - Docker
- Create a backup volume, created to host all backups.

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. Create a `backupserver` group_vars file and set up the following variables:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

3. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |urbackup_authkey|M|This is the client auth-key the server expects in case of manual internet-client setup. This is a unique key per client and can be acquired by trying to add a named client on the UI, then on the next page where the client download links are, copy the generated new key and set it in the inventory.|

## Usage

First deploy everything with the playbook

```bash
./common-run-playbook.sh --playbook backups/urbackup/deploy-urbackup.yaml --no-check
```

This will do the following:

1. Deploy UrBackup Server on the backup server
2. Deploy UrBackup client on each backup client host

Most probably you will need to rerun the playbook a second time, because you need to set for each client host an auth key on the Server UI.

For Windows clients or for clients not capable to be in automations, do the following:

1. Go into the UrBackup Server and Add a new client to get a new auth key
2. Install the client UI application manually (prefer the pre-configured one that you can download from the Add-new-client page)
3. In the client App select the folders you want to include in the backup
4. Right click on the icon to get into the Settings, and configure an Internet backup Server, be sure to set the auth key also.
5. Wait a few minutes, it shall start working

## Commands

This solution seems entirely UI based, which makes it very simple to handle.

## Notable comments

- Make sure the client has a unique auth key set and known by the server, mapped to the client identifier. To do this, first on the UI, Add a new client, make it internet/active client, write the name as the identifier of the host
