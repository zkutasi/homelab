# Ntfy

Send push notifications to your phone or desktop using PUT/POST

- [Official site](https://ntfy.sh/)
- [Source repository](https://github.com/binwiederhier/ntfy)
- [Documentation](https://docs.ntfy.sh/)
- [Image repo](https://hub.docker.com/r/binwiederhier/ntfy)
- ~~Other sites~~

## The setup

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

### Deploy the app

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

## Metrics, Alerts, Notifications

## Commands

## Notable comments

- The unique thing here is that we can define in the send the target topic, but cannot identify ourselves via a token for example. Formally topics could represent the sender, but the idea behind topics is more like to distinguish between the types of messages.
