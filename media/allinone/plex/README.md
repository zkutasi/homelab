# Plex

[Plex](https://www.plex.tv/) - Plex combines free movies & TV with the best free streaming services, so there’s always more to discover. Also supports local movies and streaming those towards endpoints.

[Tautulli](https://tautulli.com/) - The best web application to monitor, view analytics, and receive notifications about your Plex Media Server.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

## Commands

## Notable comments

- Without a Plex Pass, the client has to be on the same Subnet as the Server. This makes docker bridge networking problematic as usually the host's Subnet is totally different than the docker bridges. Plex can set up ranges for local playback ONLY with a Plex Pass, so this totally does not work. The easiest solution is to set host-mode for the network.
- Plex behind PiHole & Unbound was problematic if accessed through the local DNS record, as it identified the access as Remote. A simple solutions is to block plex.direct from resolving, making it 0.0.0.0, and then everything shall work as expected.
