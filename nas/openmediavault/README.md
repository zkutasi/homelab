# OpenMediaVault

[OpenMediaVault](https://www.openmediavault.org/) is a very lightweight NAS OS based on Debian Linux, and supports a few main NAS functionalities via plugins like NFS, Samba, Snapraid or even MergerFS.

The extra plugins are decoupled into [OMVExtras](https://wiki.omv-extras.org/) which has to be installed separately to function.

## The setup

I have 8 disks in total. 7 of them are used for data and 1 is parity in a SnapRAID array. This is not a strongly recommended setup, but it already saved my ass twice, so good enough for me. The disks are labeled as "hddXX" where XX is a number from 01 to 08.

MergerFS is used to merge together data from the 7 datadisks, and these are read-only filesystems (to protect them from those mounting them in, not to be able to delete on them for example).

These MergerFS filesystems are shared via NFS towards my HTPC (Plex, Emby, Jellyfin, etc...)

If the native filesystems are also required to be shared on NFS, that is also possible.

The native folders are shared via Samba, to facilitate Subtitle addition and editing.

## Prerequisites

Since this is an OS in itself, just a fresh empty host is required.

## Ansible inventory setup

1. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |omv_input_disks|M|The disk dictionary you have, everything is based on this. Shall have as keys disk-labels, and under them the list of the shared folders with their name and path.|
    |omv_mergerfs_pools|M|The dictionary of mergerFS pools, where keys are the pool-names and under them the shared folders.|
    |omv_nfs_allowed_clients|M|A mandatory parameter for the NFS shares.|

## Usage

Install it into a Host or a VM as the OS and then configure it on the UI. Can be a bit slow if you have a lot of things you want to do.

On the UI, you shall add a user. Use the following groups to be part of:

- _ssh
- docker
- sudo
- users

Also create a group for this user, make it so that the group name is the same as the user name.

Alternatively, use the Ansible playbook to deploy my setup:

```bash
./common-run-playbook.sh --playbook nas/openmediavault/configure-omv.yaml
```

Also, if anything goes south, on the UI you can delete, investigate and modify as well. It is just so cumbersome to change 50 shares to modify a single value.

Be sure to finish with an UI Apply, as it seems it is also required to properly finish some steps. If any setting does not work, just make sure you have it correctly in the DB (on the UI), and issue a small change on the UI for that component, then Apply. Most of the time, this will redo everything for that specific component and clean things up.

## Commands

OMV is based on [SaltStack](https://saltproject.io/), an Automation platform like Ansible. So everything is config-driven and snapshotted, it has to be applied after configuring, and therefore can be abandoned too.

Some cool and useful commands for this:

`omv-salt deploy list-dirty` - After some modification is done, this command lists the components that have changed, and needs to be applied, as they have dirty state.
`omv-salt deploy run –append-dirty` - Run all of the dirty stated components

If one needs to make changes on the CLI, there is a command for that as well, that makes changes in the internal database (/etc/openmediavault/config.xml).

`omv-confdbadm list-ids` - List the available config IDs
`omv-confdbadm read <ConfID>` - Read the given config ID fragment data
`omv-confdbadm update <ConfID> <JSONData> - Write data into the given config fragment. Pay attention, that if the config fragment is a list, each element will have a unique UUID, and this method can update directly only one element, by specifying the UUID in the JSONData. If UUID is omitted, a new element will be added to the list. Some checks are also performed to protect the integrity of the DB.

The UI does RPC calls in the background, so if that is needed, for example the code to do something is directly in the RPC call (I look at you Symlinks API :)), the following command can be used to directly communicate these RPCs.

`omv-rpc <RPCService> <RPCEndpoint> <JSONDATA>`

It is a lot trickier to know the input data here, one needs to check the code of the given plugin usually.

## Notable comments

- Automating the setup I Have was a beast, as the OMV developers does not really like not using the UI. They do have CLI Tools, but they are very cumbersome. The UI makes things super easy, but anything done in the CLI is tricky.
- Currently I could not find any good way to Apply the changes always, as sometimes `omv-confdbadm update` does it in itself, sometimes even `omv-salt deploy run` does not do it. The dirty state has always remained. According to the info I gathered, the UI does this cleanup manually. So if required, Apply on the UI.
