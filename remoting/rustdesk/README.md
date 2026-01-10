# Rustdesk

[RustDesk](https://rustdesk.com/) is a remote access software, capable of using its own Relay server, connecting two even CGNAT-ed or double-NAT-ed machines.

## The setup

Each remote controllable machine needs the RustDesk client as well as the machine that is going to remote control. Then a Relay/Rendezvous server has to be installed on somewhere that has direct connection over the internet (like a small VPS).

## Prerequisites

## Usage

### Deploy the app

1. Deploy the Relay server:

    ```bash
    ./common-ansible-run-playbook.sh --playbook remoting/rustdesk/deploy-rustdesk.yaml --no-check
    ```

2. Get the relay Server's Public Key: `cat data/id_ed25519.pub`

3. Deploy the clients manually.
   1. Note the client's unique ID, this is needed to connect to
   2. Set the password to a fixed one in Settings->Security->Password->Use permanent password. This way you do not need the assistance of the remote party... do it only if you want this of course

4. On each client, set the Settings->Network->ID/Relay Server
   1. ID Server shall be your IP/FQDN of the Relay server if you use any
   2. Relay Server shall be empty
   3. API Server shall be empty
   4. Key shall be filled only if this client will control others, and it shall be the Relay Server's Public Key, obtained before

5. Connect one client to the other
   1. You need the client ID you want to control, write it into the "Control Remote Desktop" field and press Connect
   2. Enter the credentials required

## Commands

Get the ID of a client from the CLI:

```bash
rustdesk --get-id
```

## Notable comments

- On Linux, Wayland is not supported on the controlled Host. One needs to switch back to the legacy system.
