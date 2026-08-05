# Paperless-NGX

[Paperless-NGX](http://docs.paperless-ngx.com/) - A community-supported supercharged document management system: scan, index and archive all your documents

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

1. Install with the provided script

    ```bash
    ./common-ansible-run-playbook.sh --playbook documents/paperless-ngx/deploy-paperless-ngx.yaml --no-check
    ```

## Metrics, Alerts, Notifications

## Commands

When retagging or any change is required due to some fine-tuning, run this command:

```bash
docker exec -ti paperless-ngx document_retagger -T -t -c -s -f
```

- T is tags
- t is document-type
- c is correspondent
- s is storage_path
- f is for overwriting (force mode)

## Notable comments
