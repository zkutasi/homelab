# Wazuh

[Wazuh](https://wazuh.com/) is a completely open source Security Platform with Endpoint Security, Threat INtelligence and SecOps.

## The setup

Run the dashboard and the data-stack in Kubernetes, and install the agents into the remote endpoints.

## Prerequisites

N/A

## Usage

1. Generate certificates, with the official scripts:

    ```bash
    ./certs/indexer_cluster/generate_certs.sh
    ./certs/dashboard_http/generate_certs.sh
    ```

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments
