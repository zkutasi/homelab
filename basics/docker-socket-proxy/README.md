# Docker Socker Proxy

Using the docker.sock on its own is a big security risk: you give basically root access to your Host doing this. Any malicious container can then do whatever they want. This is why agent-based solutions are better, as they do not require to expose the docker socket externally, only internally. But there are some solutions that do not ship with agents.

Also, if you use more than one network-wide docker-manager solution, the amount of agents multiply, using resources. If you already intent to do read-only socket operations, a single docker-socket-proxy might be ideal. But if modification is also needed, consider deploying these proxies per App.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Tecnativa](https://github.com/Tecnativa/docker-socket-proxy) - The OG one
- [LinuxServer.io](https://github.com/linuxserver/docker-socket-proxy) - Based on the Tecnativa solution
- [Wollomatic](https://github.com/wollomatic/socket-proxy) - A modern Go reimplementation of the Tecnativa solution, but also adding a slim docker image, IP-based access control. Configuration is regex-based.
- [11notes](https://github.com/11notes/docker-socket-proxy) - Another "popular" one, focusing on a security-scanned, non-root, distroless, read-only, very small image.
- [Cetus Guard](https://github.com/hectorm/cetusguard) - Also written in Go, and has regexp filtering rules.
