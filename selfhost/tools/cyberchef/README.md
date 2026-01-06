# Cyberchef

[Cyberchef](https://github.com/gchq/CyberChef) - CyberChef is a simple, intuitive web app for carrying out all manner of "cyber" operations within a web browser.

## The setup

## Prerequisites

## Usage

### Deploy the app

1. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    curl -s https://oci.trueforge.org/v2/truecharts/cyberchef/tags/list | jq
    ```

2. Create a values yaml file for potential private data named `app-values-private.yaml`

3. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
