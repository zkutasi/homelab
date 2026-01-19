# Caddy

[Caddy](https://github.com/caddyserver/caddy) is a state of the art reverse proxy with modular design and extensibility, while still maintaining a lightweight structure and simplicity.

## The setup

## Prerequisites

N/A

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |reverseproxy_internal_domain|M|The common suffix of the reverseproxy domain|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |exposed_services|O|A list of the services to get exposed on the given host. Each element is a map, with keys `proxy_url_prefix` and `backend_port`|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook networking/reverse-proxy/caddy/deploy-caddy.yaml --no-check
```

After deployment, the Caddyfile is also templated out. But still, the local DNS has to be set up. It can be done with the following playbook:

```bash
./common-ansible-run-playbook.sh --playbook networking/reverse-proxy/caddy/configure-caddy-pihole.yaml --no-check
```

## Commands

## Notable comments
