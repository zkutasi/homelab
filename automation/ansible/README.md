# Ansible

Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy and maintain. Automate everything from code deployment to network configuration to cloud management, in a language that approaches plain English, using SSH, with no agents to install on remote systems.

- [Official site](https://www.ansible.com/)
- [Source repository](https://github.com/ansible/ansible)
- [Documentation](https://docs.ansible.com/)
- ~~Image repo~~
- ~~Other sites~~

## The setup

One Ansible control host can access all remote machines (and even localhost as well), and can automate everything.

All kinds of automations are written, common roles, playbooks, and everything required to set things up.

The Ansible inventory is stored in a private git repository.

## Prerequisites

- A control host is required that has Ansible installed and can access to every other machine.
- An inventory set up (by hand, or stored in a private repository)

### Control windows hosts

For windows control, you need to set up WinRM. Open an Administrator CMD and issue the following:

```bash
winrm quickconfig
```

If it is not yet started, say Yes to the questions and it should get configured right away.

Then check if the Listeners are running:

```bash
winrm enumerate winrm/config/Listener
```

## Usage

### Deploy Ansible

1. Install ansible-navigator and ansible-builder (via pipx) on the control host, and build the local execution environment image `ansible-execution-environment:latest` with the provided script.

    ```bash
    ./automation/ansible/deploy-ansible.sh
    ```

### Ansible inventory setup

1. Create an inventory folder
2. In it, create a `hosts.yaml` file, list your hosts, and put them into the groups below

#### Host groups

Groups select hosts either by their kind or by the Apps they run. Variables shared by a group can go into `group_vars/<group>`.

Groups by kind of host:

|Group|Description|
|-----|-----------|
|`docker`|All hosts that prefer dockerized apps over binaries|
|`external`|Represent machines that are fully external. Requires special handling if networking is required towards other services on other Hosts.|
|`home`|Represent machines that are fully internal, on the home network.|
|`kubernetes`|The kubernetes inventory if anything is required on the hosts that Kubespray cannot do itself (Kubespray has its own inventory elsewhere)|
|`linux`|All Linux hosts, separated from Windows ones|
|`linux-selfmanaged`|All Linux hosts that are self-managed, so Linux machines except Synology for example|
|`proxmox`|All the Proxmox hosts|
|`proxmoxclusters`|The individual clusters, as some operations should not be done on all cluster Nodes|
|`standalone`|Represents the standalone machines, machines that are neither Virtual Environments nor special machines like Synology NAS-es, those require special handling a lot of times.|
|`synology`|All the Synology NAS-es, which require special care|
|`vms`|All VMs among the hosts|
|`windows`|All Windows hosts, they require a completely different set of roles|

Groups by App:

|Group|Description|
|-----|-----------|
|`backupclient`|The backup clients, those hosts that required to be backed up (install clients, set the directories, etc)|
|`backupserver`|The Backup Server that hosts all of the backups of the various hosts|
|`books`|The server that stores Books|
|`controlserver`|The server that will act as an Ansible control host, git host and terraform host as well as host for other toolings like kubernetes tools.|
|`dashboard`|The hosts that run the app dashboards (Dashy, Glance, Homepage, etc)|
|`dnsserver`|All of the local DNS servers like Pi-hole|
|`documents`|The server that holds documents|
|`emailnotifiers`|Hosts that can send emails|
|`htpc`|The HTPC hosts that run the media servers (Emby, Jellyfin, Plex)|
|`music`|The server that holds music files|
|`networkmonitoring`|Host that provides Flow analysis, IDS, and various other network monitoring capabilities|
|`nutserver`|The hosts that have a UPS attached via USB and run the NUT server|
|`omv`|The OpenMediaVault NAS host that holds the Movies, TVShows and co.|
|`photos`|The server that stores Photos|
|`remotecontrolled`|The hosts that have remote controlling apps (like RustDesk)|
|`reverseproxy`|A host used to run a reverseproxy in the whole network|
|`smart`|Hosts that require S.M.A.R.T. data to be collected|
|`torrent`|Hosts that run torrent clients|

#### User-specific variables

App-specific variables are documented in each App's own README.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |discogs_user_token|O|The API token of the user's Discogs account|
    |email_full|O|The email address used to send (and receive) notification emails|
    |email_password|O|The password of the SMTP account|
    |email_server|O|The SMTP server to send emails through|
    |email_username|O|The username of the SMTP account|
    |geoip_account_id|O|The account ID of a (free) MaxMind GeoLite2 account, to download the GeoIP databases|
    |geoip_license_key|O|A license key of that MaxMind account|
    |github_access_token|O|A GitHub personal access token of the user|
    |github_homelab_repo|O|The name of the user's homelab repository on GitHub|
    |lastfm_username|O|The user's Last.fm username|
    |listenbrainz_token|O|The user's ListenBrainz token|
    |listenbrainz_username|O|The user's ListenBrainz username|
    |pushover_user|O|The Pushover user key of the account to send to|
    |timezone|M|The timezone to be set in all containers and on the host as well|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

#### Network-specific variables

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |localdns_extra_cname_entries|O|A map of extra CNAME records, alias name to target name, both without the domain (e.g. `files: nas`)|
    |localdns_extra_entries|O|A map of extra DNS records, name to IP address, the name without the domain (e.g. `nas: 192.168.1.5`)|
    |network_domain|M|The local network domain all hosts and services are reachable under (e.g. `home`)|
    |network_subnet|M|The network subnet that defines all of the machines' IP addresses, CIDR notation|
    |pihole_address|M|The full URL to the Primary Pi-hole instance in order to call its API|
    |pihole_password|M|The password set up for Pi-hole, the same on both instances|
    |reverseproxy_internal_domain|M|The common suffix of the reverseproxy domain|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |exposed_services|O|A list of the services running on the host that are published on the network|
    |exposed_services.name|M|The name of the service|
    |exposed_services.type|M|The kind of service: `http` for web services behind the reverse proxy, `tcp` for plain network ports|
    |exposed_services.backend_port|M|For `http`, the port the service listens on. For `tcp`, a map with `tcp` and/or `udp` lists of ports|
    |exposed_services.proxy_url_prefix|M (http)|The subdomain the service gets under the reverse proxy domain|
    |exposed_services.icon|O|The icon of the service: a selfh.st icon name or a full URL. Default is the service name|
    |exposed_services.insecure_also|O|Whether the service is also reachable over plain HTTP. Default is false|
    |exposed_services.redirection_path|O|A path the root URL redirects to (e.g. `/admin`)|
    |exposed_services.https_skip_verify|O|Whether the backend speaks HTTPS with a certificate that is not verified. Default is false|
    |exposed_services.accepted_extra_statuscodes|O|A list of extra HTTP status codes that count as healthy (e.g. `[401]` for a login-protected service)|
    |network_interface|O|The name of the host's main network interface (e.g. `eno1`)|

#### Host variables

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set (a common default can also go into `group_vars/all`)

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |ansible_connection|O|If you set up the local ansible host as well, set this to local on that inventory host|
    |ansible_host|M|The IP address of the machine|
    |ansible_port|O|If the port of the SSH access is different than 22, set it here. Default is 22|
    |ansible_user|M|The user to enter via SSH onto the corresponding host|
    |ansible_ssh_pass|O|If you have SSH password set, set it here, otherwise set passwordless SSH with SSH keys|
    |ansible_become_pass|O|If you have sudo password set, set it here, otherwise set up passwordless sudo first|
    |id|M|The string identifier of a corresponding host, used throughout all of the roles. Usually it is the name of the server/client/host|
    |path_extension_list|O|A list of extra folders to put in front of the PATH when running commands|

### Post deployment

## Metrics, Alerts, Notifications

## Commands

Some helper scripts are placed in the repo to ease the execution of the playbooks.

- `run-ping.sh` - The very first thing to do is to check your inventory setup, whether the IPs work or not
- `run-fact-gathering.sh` - Useful to get all the magic variables and facts Ansible would get automatically.
- `common-ansible-run-playbook.sh` - A wrapper script to execute a playbook. By default it runs with check-mode and diff-mode. Check the usage of it if needed.
- `ansible-lint.sh` - Lint the Ansible code of the whole repo.
- To check whether the config files are applied or not, one can run for example `ansible-navigator exec -- ansible-config dump --only-change`, to list the non-default configurations

## Notable comments

- It seems ansible-runner via the ansible-navigator ecosystem by default injects `awx_display` into the default output callback, and this wraps the original settings in other places, however this one does not 100% support everything, for example the YAML output feature. To turn this off, and return to the original default, one needs to inject back via ENV variables, I found no other way.
- The execution environment pins `ansible-core` (`ansible-core<2.18` in `ansible-execution-environment/execution-environment.yaml`), because KubeSpray runs through the same execution environment and every KubeSpray release only accepts one `ansible-core` minor version (v2.30 needs 2.17, v2.31 needs 2.18, v2.32 needs 2.19). When KubeSpray is upgraded, move the pin to the version it requires. Hosts still on Python 3.8 (e.g. the Synology NASes) cannot go beyond `ansible-core` 2.19.
