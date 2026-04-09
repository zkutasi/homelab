# Homer

[Homer](https://homer-demo.netlify.app/) - Homer is a dead simple static HOMepage for your servER (or anything else) to keep your services and favorite links on hand, based on a simple yaml configuration file.

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
./common-ansible-run-playbook.sh --playbook dashboard/homer/deploy-homer.yaml --no-check
```

## Commands

## Notable comments

- Smart cards are unique widgets to represent specific things on a card, however it is only possible to attach one to every card. Since `Ping` is a smart card, it is not possible to ping & display something more meaningful.
- The smartcards are very limited, usually they show one single info only. In case of Emby for example it only shows one library type's number of elements. No way to show more data in a wider card.
- CORS is very fundamental for Homer, the remote services shall be configured properly for CORS to function. Mixed content still is not allowed though.
- The `Ping` widget seems very limited: more often than not it cannot show a service as online, due to either CORS issues or Unauthorized access problems, but sometimes the reason was simply not found.
