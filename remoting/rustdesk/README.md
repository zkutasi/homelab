# Rustdesk

[RustDesk](https://rustdesk.com/) is a remote access software, capable of using its own Relay server, connecting two even CGNAT-ed or double-NAT-ed machines.

## The setup

Each remote controllable machine needs the RustDesk client as well as the machine that is going to remote control. Then a Relay/Rendezvous server has to be installed on somewhere that has direct connection over the internet (like a small VPS).

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |rustdesk_server_address|M|To generate the config, this has to be set|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |rustdesk_password|M|The host's password to login remotely after|

### Deploy the server

1. Deploy the Relay server:

    ```bash
    ./common-ansible-run-playbook.sh --playbook remoting/rustdesk/server/deploy-rustdesk.yaml --no-check
    ```

2. Get the relay Server's Public Key: `cat data/id_ed25519.pub`

### Deploy the clients manually

1. Deploy the clients manually.
   1. Note the client's unique ID, this is needed to connect to
   2. Set the password to a fixed one in Settings->Security->Password->Use permanent password. This way you do not need the assistance of the remote party... do it only if you want this of course

2. On each client, set the Settings->Network->ID/Relay Server
   1. ID Server shall be your IP/FQDN of the Relay server if you use any
   2. Relay Server shall be empty
   3. API Server shall be empty
   4. Key shall be filled only if this client will control others, and it shall be the Relay Server's Public Key, obtained before

3. Connect one client to the other
   1. You need the client ID you want to control, write it into the "Control Remote Desktop" field and press Connect
   2. Enter the credentials required

### Deploy the clients with Ansible

```bash
./common-ansible-run-playbook.sh --playbook remoting/rustdesk/client/deploy-rustdesk.yaml --no-check
```

The client IDs will be printed to the output, for the setup of the controlling client.

## Commands

Get the ID of a client from the CLI:

```bash
rustdesk --get-id
```

## Notable comments

- On Linux, Wayland is not supported on the controlled Host. One needs to switch back to the legacy system.
