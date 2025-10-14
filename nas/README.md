# NAS systems

A Network Attached Storage (NAS) system is either an OS or a set of tools to facilitate the handling of disks, mounts, sharing and has the possibility to extend the system too with Applications that have something to do with data.

## Requirements

- Handle disks not just with RAIDx or ZFS, but also with raw data, so no need to start fresh and format the disks
- Has at least support for SnapRAID and MergerFS, NFS and Samba
  - Why SnapRAID? Check out [this comparison](https://www.snapraid.it/compare), where a deep-dive into the different solutions is done. Simply put, if you already have some filled disks, different sizes that mainly will store BIG files, rarely changing, SnapRAID is the BEST system to use.
  - Why MergerFS? I have set up to use SnapRAID, so handling all of those disks unified is required on the App layer. I opted a data structure where I have the very same folders on every disk, and I want to pool them into a read-only merged filesystem, so I could export these as NFS and Samba shares to other hosts
  - I use NFS to 1) mount read-write shares for remote hosts (if needed, I prefer to run these containers locally though to avoid these shares) 2) mount read-only shares for HTPC usage (mainly the MergerFS ones)
  - I use Samba to handle Subtitles (using [Subtitle Edit](https://www.nikse.dk/subtitleedit)) mainly
- Ability to run docker images to vastly extend the system (metrics, logs, apps, etc...)
- Has lots of automations, a GUI and metrics about the disks and the systems under control

## Contenders

- [OpenMediaVault](https://www.openmediavault.org/) - A Very lightweight solution based on Debian, with plugin support for SnapRAID, MergerFS, and native support for NFS and Samba, among many others. Has a lightweight GUI and also supports docker-compose too.
- [TrueNAS](https://www.truenas.com/) - A beast and a very versatile contender, based on the ZFS filesystem. Requires same-sized disks and expansion is not that easy as with others. TrueNAS Core focuses on NAS functionality and data integrity while TrueNAS Scale brings in Kubernetes and a plethora of Apps able to run inside of it and more cloud functionalities.
- [Synology DSM](https://www.synology.com/en-us/dsm/) - The NAS OS from Synology, only usable on their Hardware. A very robust ecosystem with a highly customized Linux based OS, and Apps for everything, but if it is not enough, it also supports Docker Compose. One downside is the extremely customized OS as it makes life a bit harder for tinkerers, but for Novice people, it is a very easy to handle system.
- [UnRaid](https://unraid.net/) - A NAS OS that is similar to TrueNAS, also based on ZFS. A very big bonus is that they utilize a system where the disks can be of any size, adding one for data or parity is very easy, so scaling on-the-go is a breeze. One big downside is that it is not completely free and requires a one-time payment.
