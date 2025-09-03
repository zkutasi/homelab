# Cup

[Official Site](https://github.com/sergi0g/cup). A very lightweight solution.

## The setup

I run this in my Kubernetes cluster and configured so that it watches all of the remote Hosts. No Kubernetes support as of yet though, so that part is not monitored at all. Also, I required to spin up a Docker-in-Docker sidecar, as the tool does not yet support a non-docker-host install, and wants to connect locally always. A Workaround of course is to just install it on one of your Docker hosts.

## Prerequisites

N/A

## Usage

1. Create a `cup.json` file with the config you want. If no such file is present, the deployer will create one for you with empty data.

2. Install with the provided script

    ```bash
    ./deploy.sh
    ```

## Commands

## Notable comments
