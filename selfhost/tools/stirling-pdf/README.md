# Stirling PDF

[Stirling PDF](https://www.stirlingpdf.com/) is a free alternative to the Adobe PDF suite with helpful tools to manipulate and read PDF files.

## The setup

Installing it into the Kubernetes cluster next to the other tools.

## Prerequisites

N/A

## Usage

### Install the central component

1. Add the helm repository

    ```bash
    helm repo add stirling-pdf https://stirling-tools.github.io/Stirling-PDF-chart
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo stirling-pdf/stirling-pdf -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
