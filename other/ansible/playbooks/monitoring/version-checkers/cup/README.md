# Cup

[Cup](https://github.com/sergi0g/cup) is a lightweight check-only docker image version checker.

## The setup

I prefer to use my Kubernetes cluster to view dashboards, so I have prepared a helm chart for cup. This instance will be the server, collecting all of the other instances' data.

Otherwise, all docker-executing hosts will have one cup docker container running acting as workers.

## Prerequisites

## Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |cup_control_server|O|The name of the cup instance that shall be the controller of the system, if any. In my case, this will be not set as the control-server will be running inside K8s|
    |cup_registries|O|A map of registries and their access tokens if a rate-limit is reached and the app starts behaving erratic due to the Unauthorized issues.|
    |cup_servers|O|A list of Servers the control-server shall handle as remotes. Since the control-server runs in Kubernetes, this is not needed here.|

## Usage

First deploy the workers:

```bash
./run-playbook.sh --playbook playbooks/monitoring/version-checkers/cup/deploy-cup.yaml --no-check
```

Optionally deploy the control-server in K8s.

## Notable comments

- Sometimes cup states that a certain container image cannot be read from the repo due to Unauthorized issue. This indicates that the public anonymous access APIs have hit their rate limits. It is advised to generate an access token for each problematic repo and set them up to try to mitigate these issues.
