# Cup

[Cup](https://github.com/sergi0g/cup) is a lightweight check-only docker image version checker.

## The setup

Run this in my Kubernetes cluster and configured so that it watches all of the remote Hosts. No Kubernetes support as of yet though, so that part is not monitored at all. Also, I required to spin up a Docker-in-Docker sidecar, as the tool does not yet support a non-docker-host install, and wants to connect locally always. A Workaround of course is to just install it on one of your Docker hosts.

## Prerequisites

N/A

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |cup_control_server|O|The name of the cup instance that shall be the controller of the system, if any. In my case, this will be not set as the control-server will be running inside K8s|
    |cup_registries|O|A map of registries and their access tokens if a rate-limit is reached and the app starts behaving erratic due to the Unauthorized issues.|
    |cup_servers|O|A list of Servers the control-server shall handle as remotes. Since the control-server runs in Kubernetes, this is not needed here.|

### Deploy the workers

```bash
./common-ansible-run-playbook.sh --playbook monitoring/image-version-checker/cup/deploy-cup.yaml --no-check
```

### Deploy the central component

1. Create a `cup.json` file with the config you want. If no such file is present, the deployer will create one for you with empty data.

2. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

## Commands

## Notable comments

- Sometimes cup states that a certain container image cannot be read from the repo due to Unauthorized issue. This indicates that the public anonymous access APIs have hit their rate limits. It is advised to generate an access token for each problematic repo and set them up to try to mitigate these issues.
