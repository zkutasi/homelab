# OpenVAS

[OpenVAS](https://www.openvas.org/) - A full-featured vulnerability scanner. Its capabilities include unauthenticated and authenticated testing, various high-level and low-level internet and industrial protocols, performance tuning for large-scale scans and a powerful internal programming language to implement any type of vulnerability test.

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

```bash
./common-ansible-run-playbook.sh --playbook security/openvas/central/deploy-openvas.yaml --no-check
```

For some reason the DB is not initialized at all in this scenario. Initialize it with the following command for the `pg-gvm` container to come up properly:

```bash
docker run --rm -it \
  --user root \
  --entrypoint /bin/bash \
  -v psql_data:/var/lib/postgresql \
  -v psql_socket:/var/run/postgresql \
  registry.community.greenbone.net/community/pg-gvm:22.6.15 \
  gosu postgres /usr/lib/postgresql/17/bin/initdb -D /var/lib/postgresql/17/main
```

## Commands

## Notable comments
