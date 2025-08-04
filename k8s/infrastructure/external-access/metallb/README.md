# MetalLB

[Official Site](https://metallb.io/)

## The setup

The external access of the services inside the cluster wil be provided on the IP level via MetalLB.

## Prerequisites

- A few IP addresses -> Set them in file `ipaddresspool.yaml`

## Usage

1. Add the helm repository

    ```bash
    helm repo add metallb https://metallb.github.io/metallb
    helm repo update
    ```

2. Check which version you want to install

    ```bash
    helm search repo metallb/metallb -l
    ```

3. Install with the provided script

    ```bash
    ./install.sh
    ```

## Commands

## Notable comments
