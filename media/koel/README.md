# Koel

[Koel](https://koel.dev/) - A simple web-based personal audio streaming service written in Vue on the client side and Laravel on the server side. Targeting web developers, Koel embraces some of the more modern web technologies to do its job.

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |koel_db_password|M|The DB password|
    |koel_app_key|M|A Laravel encryption key|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the app

1. Generate a Laravel App-key with this [Laravel Key Generator](https://generate-random.org/laravel-key-generator) and set it in `koel_app_key`.

2. Then install with:

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/koel/deploy-koel.yaml --no-check
    ```

3. Init the DB with:

    ```bash
    ./common-ansible-run-playbook.sh --playbook media/koel/configure-koel-init.yaml --no-check
    ```

4. When navigating to the UI, use the default credentials of `admin@koel.dev/KoelIsCool`

## Commands

- Scan the Music folder with this command:

    ```bash
    docker exec -u www-data -ti koel php artisan koel:sync
    ```

## Notable comments

- It is weird that I need to init the DB with the `koel:init` command, although the docker container should do this for me.
- I could not Scan in the background and no indication about the scanning progress... also the scan is possible from the CLI, but who wants to do that? They state in the Docs that a "decent sized" library shall not scan via the Web UI, which is a bit harsh.
- About 10 minutes in, I was able to scan only for 150 albums/songs, without artwork. With my library of 100k songs, this is absolutely too slow.
