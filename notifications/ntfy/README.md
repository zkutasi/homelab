# Ntfy

[Ntfy](https://ntfy.sh/) - Send push notifications to your phone or desktop using PUT/POST

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/ntfy/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- The unique thing here is that we can define in the send the target topic, but cannot identify ourselves via a token for example. Formally topics could represent the sender, but the idea behind topics is more like to distinguish between the types of messages.
