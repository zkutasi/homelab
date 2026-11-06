# GitOps

Helps to do chores: updates of versions on binaries, helm charts, and docker images.

An end-to-end automatic GitOps workflow might look like this:

1. Dependency Automation: Checks GitHub/dockerhub or other places for release updates of configured projects and also knows where and how those releases are used in this repo. Creates Pull Requests (PRs) for these small changes, waiting for Automatic CI to pass and for human approval.
2. Version control: Where the source code lives. Can be GitHub, GitLab, Codeberg or anything git-like. Or it can be totally self-hosted. Possible to sync more registries, so for example a private one to a public one.
3. Runners: Triggerable activities when a PR is opened. Can be GitHub Actions, GitLab CI or other matching. Also in case of self-hosted counterparts, the corresponding runners can be set up. The tricky part comes in, where the Runner is executed and what access does it have into the homelab. Of course on the selfhosted ones, it is completely inside the local network. In case of GitHub for example, Runners can be self-hosted as well, so they could deploy a canary release for example.
4. Continuous Delivery: Notices changes in the git repo about what is deployed and what should be deployed. Reconciles the differences (updates in this case the versions and redeploy/upgrade)

## Requirements

- Free and Open source, preferably 0$ cost
- Ability to handle Kubernetes, and potentially docker hosts as well
- Has a UI
- Extensible, flexible

## Contenders

### Dependency Automation

- [Dependabot](https://github.com/dependabot/dependabot-core)
- [Renovate](https://github.com/renovatebot/renovate)

### Version control (self-hosted ones)

- [Gogs](https://gogs.io/) - The painless way to host your own Git service
- [GitLab](https://about.gitlab.com/)
- [Gitea](https://gitea.com/) - Git with a cup of tea! Painless self-hosted all-in-one software development service, including Git hosting, code review, team collaboration, package registry and CI/CD
- [Forgejo](https://forgejo.org/)

### Continuous delivery

#### Kubernetes

- [ArgoCD](https://argoproj.github.io/cd/)
- [FluxCD](https://fluxcd.io/)

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
