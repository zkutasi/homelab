# Docker Socket Proxy

Using the docker.sock on its own is a big security risk: you give basically root access to your Host doing this. Any malicious container can then do whatever they want. This is why agent-based solutions are better, as they do not require to expose the docker socket externally, only internally. But there are some solutions that do not ship with agents.

Also, if you use more than one network-wide docker-manager solution, the amount of agents multiply, using resources. If you already intend to do read-only socket operations, a single docker-socket-proxy might be ideal. But if modification is also needed, consider deploying these proxies per App.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Tecnativa](https://github.com/Tecnativa/docker-socket-proxy) - The OG one
- [LinuxServer.io](https://github.com/linuxserver/docker-socket-proxy) - Based on the Tecnativa solution
- [Wollomatic](https://github.com/wollomatic/socket-proxy) - A modern Go reimplementation of the Tecnativa solution, but also adding a slim docker image, IP-based access control. Configuration is regex-based.
- [11notes](https://github.com/11notes/docker-socket-proxy) - Another "popular" one, focusing on a security-scanned, non-root, distroless, read-only, very small image.
- [Cetus Guard](https://github.com/hectorm/cetusguard) - Also written in Go, and has regexp filtering rules.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
