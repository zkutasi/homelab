# Backup solutions

A Collection of backup solution I investigated or even tried out.

In the network, there are Linux VMs, Linux Baremetal Hosts and 1-2 Windows Host.

## Requirements

- Incremental backups
- Deduplication, possibly across hosts as well
- Encryption
- Support for Linux as well as Windows
- Centralized management with web GUI (Native UI is not OK)
- Preferrably agent-based (SSH would not be on Windows)
- Server is dockerized, agents could be dockerized or single-binary
- Free and Open source, preferrably 0$ cost
- Local, remote and cloud support (possibly with RClone) for repositories

## What to back up (non-exhaustive list)

- Git repo untracked files
  - Inventories
  - Helm chart custom values.yaml files
- Docker Volumes
- Knowledgebase txt and Obsidian Markdown files
- Linux/Windows Server home folders
  - Configuration files
  - Browser profiles with bookmarks, passwords
- Important documents (shall be moved into a Document repository too)
- Family Photos/Videos (they are stored on Google Photos though)
- Kubernetes Databases

## Contenders

### Honorable mentions

- [RClone](https://rclone.org/) - This is the final step of the process to ship backups to any cloud provider, but is not a backup software in itself. This is a popular pattern: do the backup with any tool (borg, restic, etc...) and then rclone to your favourite cloud provider storage.
- [Syncthing](https://syncthing.net/) - Just synchronizes files/folders, does not do backups. So if the change happening on the file is wrong/destructive, it will still be synced.

### Synology Active Backup for Business

If someone has a Synology NAS, this is a pretty good alternative. It seems to support many things required. Vendor lock-in though is a thing here.

### Proxmox Backup Server (PBS)

[Official Site](https://www.proxmox.com/en/products/proxmox-backup-server/overview)

Cons:

- No Windows support
- Primarily intended for VM and LXC backups, so file-based backups are rudimentary at best

### Borg

[Official Site](https://www.borgbackup.org/)

Other things to consider:

- [Community Resources](https://github.com/borgbackup/community)
- [BorgMatic](https://github.com/borgmatic-collective/borgmatic) - A wrapper that makes things easier
- [BorgWarehouse](https://borgwarehouse.com/) - Centralized webUI for the Server-handling (so does not handle the client Hosts)
- [BorgBase](https://www.borgbase.com/) - Cloud Repo solution
- Docker
  - [Docker image for Borgmatic clients](https://github.com/borgmatic-collective/docker-borgmatic)
  - [Docker image & Helm Chart for the Backup Server](https://github.com/AnotherStranger/docker-borg-backup/)

A Borg Repository Server acts as storage of backups and multiple clients can write into this, into different folders per Host. Clients can initialize themselves to write remotely via SSH into the Repository Server into their own folders. How to setup all of this is instructed [here](https://borgbackup.readthedocs.io/en/1.4-maint/deployment/central-backup-server.html).

The Borgwarehouse GUI has to be deployed next to the Repository Server (or even it could act as a repository Server?), so it is not an option for Cloud Storage. But if clients would set up themselves to back up both into Cloud and into a local Borg Repo, then things would be simpler a bit, though would require local storage too to store the backups.

Cons:

- No native Windows support (WSL/Cygwin only)
- Non-Agent based, Works over SSH
- Central management with BorgWarehouse is only for repositories, not actual backups/restores

### Bacula/Bareos

[Bacula](https://www.bacula.org/)

[Bareos](https://www.bareos.com/) - Bareos is a FOSS fork of Bacula. Seems more promising.

The director, storage daemon, web-ui and api components together with a postgresql/mysql database has to be on the Server Host. Client component is needed on the Server Host (due to backing up things there) and on Client Hosts too; practically wherever backing up is required. All of them have separate docker images. One can find some latest images on DockerHub to be used, but it would maybe be wise to build one locally as there is no official images built.

Cons:

- Very complex setup, steep learning curve

### Restic

[Official Site](https://restic.net/)

Other things to consider

- [AutoRestic](https://autorestic.vercel.app/) - Make the CLI configurable via YAML
- [Backrest](https://github.com/garethgeorge/backrest) - a WebUI for Restic

Official docker container exists with the restic binary, which has to be installed on the Hosts that requires backups to do. The Backrest GUI is also a single binary, the docker image most probably contains both of them in one. Therefore there is no central management of Hosts (yet).

Cons:

- No central management possible, the webUI (backrest) is local to the host (this is incoming, see [here](https://github.com/garethgeorge/backrest/issues/68), proposed to be ready in 1.9.0+)
- Non-Agent based, Works over SSH, remote hosts must be mounted

### Kopia

[Official Site](https://kopia.io/)

Kopia natively supports many local or remote repos, being it a remove Host, NAS or Cloud provider, though only one can be selected at once, so not possible to do a local and a cloud backup at the same time with one instance. The developers provide docker images and there is also a helm chart available too.

In server mode, the webUI is going to be active, managing multiple machines with it is possible. All of the managed client Hosts have to install Kopia somehow in non-server mode (docker or binary).

Cons:

- The webUI is only able to connect to one repository at once ?

### Duplicacy

[Official Site](https://duplicacy.com)

Duplicacy can back up folders on the local host only. Therefore it must be installed on all of the Hosts. A multi-host feature was planned, but it seems it was ditched (see [here](https://forum.duplicacy.com/t/allow-a-single-web-ui-to-manage-multiple-workstations/8425)). No official docker container exists, but there are people who create them and publish them on DockerHub. It is imperative to know, that there are two binaries: duplicacy and duplicacy-web, so the latter is needed for the WebUI. Chose a docker image that contains this one too.

Cons:

- Not free (CLI is, GUI seems not)
- No central management, webUI is per Host
- Not agent-based therefore

### Duplicity

[Official Site](https://duplicity.us/)

Cons:

- No GUI
- No deduplication
- No native support for Windows (WSL or cygwin only)
- Not agent based
- Generally very old

### Duplicati

[Official Site](https://duplicati.com/) - A C# reimplementation of Duplicity

Official docker images are available: there is duplicati and duplicati-agent. Supports all kinds of cloud providers too.

Cons:

- Numerous angry customers due to backup & database corruption
- No built in centralized management, webUI is per Host on the free tier... though there is a Duplicati Console which is intended as the centralized management. Though not so many info can be found about it.

### Veeam

[Official Site](https://www.veeam.com/)

Since Veeam requires a central Windows machine, it completely falls short.

Cons:

- The central server requires Windows (Linux support is coming in 2025)
- Not dockerized

### UrBackup

[Official Site](https://www.urbackup.org/)

Client-Server architecture, there is an official Server docker image present, and for clients, single binaries for all kinds of OSes.

Cons:

- No cross-host deduplication
- No direct cloud support, needs RClone or similar

### Minarca

[Official Site](https://minarca.org)

Cons:

- No encryption at rest, only at transport

### Nakivo

[Official Site](https://www.nakivo.com/)

Cons:

- Not free

## Offsite cloud providers

- [Hetzner Storage Box](https://www.hetzner.com/storage/storage-box/) - 3euro/1TB/month
- [Backblaze B2](https://www.backblaze.com/cloud-storage/pricing) - 6$/1TB/month
- [iDrive E2](https://www.idrive.com/s3-storage-e2/pricing#monthly-plans) - 5$/1TB/month
- [Wasabi](https://wasabi.com/pricing) - 7$/1TB/month, no egress cost
- [rsync.net](https://rsync.net/pricing.html) - 1.2cent/GB/month (9.6$/1TB/month)
- [Amazon S3 Glacier](https://aws.amazon.com/s3/pricing/?nc=sn&loc=4) - 4$/1TB/month
- [Google Cloud Storage Archive](https://cloud.google.com/storage/pricing#europe) - 1.2$/1TB/month
- [DigitalOcean Spaces S3](https://www.digitalocean.com/pricing/spaces-object-storage) - 5$/250GB/month
- [Jottacloud](https://jottacloud.com/en/pricing?category=jottacloud-personal) - 6.9euro/1TB/month, also have unlimited for 12euro/month
- [Cloudflare R2](https://www.cloudflare.com/developer-platform/products/r2/) - 15$/1TB/month, no egress cost
- [Scaleway Glacier S3](https://www.scaleway.com/en/pricing/storage/#scaleway-glacier) - 2euro/1TB/month
