# OpenMediaVault

openmediavault is the next generation network attached storage (NAS) solution based on Debian Linux. It contains services like SSH, (S)FTP, SMB/CIFS, DAAP media server, RSync, Kubernetes and many more ready to use.

- [Official site](https://www.openmediavault.org/)
- ~~Source repository~~
- [Documentation](https://docs.openmediavault.org)
- ~~Image repo~~
- ~~Other sites~~

The extra plugins are decoupled into [OMVExtras](https://wiki.omv-extras.org/) which has to be installed separately to function.

## The setup

I have 8 disks in total. 7 of them are used for data and 1 is parity in a SnapRAID array. This is not a strongly recommended setup, but it already saved my ass twice, so good enough for me. The disks are labeled as "hddXX" where XX is a number from 01 to 08.

MergerFS is used to merge together data from the 7 datadisks, and these are read-only filesystems (to protect them from those mounting them in, not to be able to delete on them for example).

These MergerFS filesystems are shared via NFS towards my HTPC (Plex, Emby, Jellyfin, etc...)

If the native filesystems are also required to be shared on NFS, that is also possible.

The native folders are shared via Samba, to facilitate Subtitle addition and editing.

## Prerequisites

Since this is an OS in itself, just a fresh empty host is required.

## Usage

### Ansible inventory setup

Variables that are shared by several Apps are not listed here, but in the more generic README files higher up in the folder structure, that cover all Apps or a whole group of Apps. Only the variables specific to this App are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |omv_password|O|The password of an OMV web UI user, for API access|
    |omv_username|O|The username of an OMV web UI user, for API access|
    |port_omv|O|The port of the OpenMediaVault web UI (80 by default)|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |omv_input_disks|M|The disks to configure, keyed by disk label. Disks with other labels are left alone|
    |omv_input_disks.\<label\>.snapraid_role|M|The role of the disk in the SnapRAID array: `data` or `parity`|
    |omv_input_disks.\<label\>.shared_folders|O|A list of the shared folders on the disk|
    |omv_input_disks.\<label\>.shared_folders.name|M|The name of the shared folder in OMV, unique across all disks and pools|
    |omv_input_disks.\<label\>.shared_folders.path|M|The folder, relative to the root of the disk|
    |omv_input_disks.\<label\>.shared_folders.privileges|O|A list of `user:<name>:ro`, `user:<name>:rw`, `group:<name>:ro` or `group:<name>:rw`. Without it, the privileges already in OMV are kept|
    |omv_input_disks.\<label\>.shared_folders.share_as_nfs|O|Whether the folder is exported read-only over NFS. Default is `omv_shared_folders_as_nfs_shares` (false)|
    |omv_input_disks.\<label\>.shared_folders.share_as_samba|O|Whether the folder is shared over Samba. Default is `omv_shared_folders_as_samba_shares` (true)|
    |omv_mergerfs_createpolicy|O|The MergerFS create policy of the pools. Default is `erofs`, which refuses to create files, so the pools stay read-only|
    |omv_mergerfs_pools|M|The MergerFS pools, keyed by pool name|
    |omv_mergerfs_pools.\<pool\>.shared_folders|M|A list of the shared folders on the pool, always exported read-only over NFS|
    |omv_mergerfs_pools.\<pool\>.shared_folders.name|M|The name of the shared folder in OMV, unique across all disks and pools|
    |omv_mergerfs_pools.\<pool\>.shared_folders.path|M|The folder, relative to the root of the pool|
    |omv_mergerfs_pools.\<pool\>.shared_folders.privileges|O|Same form as for the disks' shared folders|
    |omv_mergerfs_pools.\<pool\>.shared_folders.share_as_samba|O|Same as for the disks' shared folders|
    |omv_nfs_allowed_clients|M|The clients allowed to mount the NFS exports: a host name, an IP address or a network (e.g. `192.168.1.0/24`)|
    |omv_shared_folders_as_nfs_shares|O|Whether a shared folder without `share_as_nfs` is exported over NFS. Default is false|
    |omv_shared_folders_as_samba_shares|O|Whether a shared folder without `share_as_samba` is shared over Samba. Default is true|
    |omv_snapraid_array_name|M|The name of the SnapRAID array to create|

### Deploy the app

Install the OMV as the OS.

### Post deployment

Configure it on the UI. Can be a bit slow if you have a lot of things you want to do.

On the UI, you shall add a user. Use the following groups to be part of:

- _ssh
- docker
- sudo
- users

Also create a group for this user, make it so that the group name is the same as the user name. Make sure this user has access to all of the required Shared folders, otherwise the containers running under this user will not work properly. This can be set under the User settings, next to the Edit button (Shared Folder Permissions)

Alternatively, use the Ansible playbook to deploy my setup. First run it in check mode (the wrapper's default), which is the plan: every write it would do in OMV's database is shown as a diff, and nothing is changed:

```bash
./common-ansible-run-playbook.sh --playbook nas/openmediavault/configure-omv.yaml
```

If the plan looks right, do the real run with `--no-check`:

```bash
./common-ansible-run-playbook.sh --playbook nas/openmediavault/configure-omv.yaml --no-check
```

Each area (system, mounts, symlinks, sharedfolders, snapraid, mergerfs, nfs, samba) has its own tag, so a single area can be planned or applied alone, for example the NFS shares:

```bash
./common-ansible-run-playbook.sh --playbook nas/openmediavault/configure-omv.yaml --no-check --extra-args "--tags nfs"
```

On a fresh OMV, the areas build on each other's entries (the plugins come with the system area, the shared folders sit on the mounts, the shares on the shared folders), so a full check run fails there. Go area by area instead, in the order system, mounts, symlinks, sharedfolders, snapraid, mergerfs, nfs, samba: a check run with `--extra-args "--tags <area>"` plans the next area, and the same command with `--no-check` applies it.

Also, if anything goes south, on the UI you can delete, investigate and modify as well. It is just so cumbersome to change 50 shares to modify a single value.

The playbook applies the changes of each area itself, the same way the UI's Apply button does, for the OMV modules that OMV marks for such a change. If any setting still does not work, make sure you have it correctly in the DB (on the UI), and issue a small change on the UI for that component, then Apply. Most of the time, this will redo everything for that specific component and clean things up.

## Metrics, Alerts, Notifications

## Commands

OMV is based on [SaltStack](https://saltproject.io/), an Automation platform like Ansible. So everything is config-driven and snapshotted, it has to be applied after configuring, and therefore can be abandoned too.

Some cool and useful commands for this:

`omv-salt deploy list-dirty` - After some modification is done, this command lists the components that have changed, and needs to be applied, as they have dirty state.
`omv-salt deploy run --append-dirty` - Run all of the dirty stated components

If one needs to make changes on the CLI, there is a command for that as well, that makes changes in the internal database (/etc/openmediavault/config.xml).

`omv-confdbadm list-ids` - List the available config IDs
`omv-confdbadm read <ConfID>` - Read the given config ID fragment data
`omv-confdbadm update <ConfID> <JSONData>` - Write data into the given config fragment. Pay attention, that if the config fragment is a list, each element will have a unique UUID, and this method can update directly only one element, by specifying the UUID in the JSONData. If UUID is omitted, a new element will be added to the list. Some checks are also performed to protect the integrity of the DB.

The UI does RPC calls in the background, so if that is needed, for example the code to do something is directly in the RPC call (I look at you Symlinks API :)), the following command can be used to directly communicate these RPCs.

`omv-rpc <RPCService> <RPCEndpoint> <JSONDATA>`

It is a lot trickier to know the input data here, one needs to check the code of the given plugin usually.

## Notable comments

- Automating the setup I have was a beast, as the OMV developers does not really like not using the UI. They do have CLI Tools, but they are very cumbersome. The UI makes things super easy, but anything done in the CLI is tricky.
- `omv-confdbadm update` only writes the database: it marks no module for an apply, unlike the UI and the RPCs, which fire OMV's change events. And `omv-salt deploy run` applies a module but leaves it on the UI's list of pending changes. The UI's Apply button calls `omv-rpc Config applyChanges '{"modules": [...], "force": true}'`, which does both, so the playbook uses that. The modules per kind of change come from OMV's engine modules (their listeners in `/usr/share/openmediavault/engined/module`).
- The playbook only adds and updates entries in OMV, it never removes any. Whatever is dropped from the inventory (a disk, a shared folder, a pool) stays configured in OMV until it is deleted on the UI.
