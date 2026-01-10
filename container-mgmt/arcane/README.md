# Arcane

[Arcane](https://getarcane.app/) - Modern docker management. Handles multiple hosts.

## The setup

Install the central component into the Kubernetes cluster and handle all other hosts as agents.

NOTE: This does not work yet, as Arcane requires the docker socket to be present and otherwise on the UI there is no way to progress further. I have asked the devs for this feature.

## Prerequisites

## Usage

### Deploy the app

1. Create a values yaml file for potential private data named `app-values-private.yaml`

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
