# Reverse Proxies

A reverse proxy further helps by eliminating the need to remember port numbers: An FQDN now can be assigned to a host+port, simplifying things further.

## Requirements

- Automation-friendly, possibly has an API too
- Useful to have a GUI, but at least some metrics for Grafana to show
- Easy to set up, not requiring many moving parts

## Contenders

- [Caddy](https://github.com/caddyserver/caddy) - The number one modern solution, modular, simple
  - [Caddy Manager](https://caddymanager.online) if there are multiple Caddy instances to manage, and a nice enough UI for them.
- [Traefik](https://github.com/traefik/traefik) - Popular proxy based on labeling and auto-discovery
- [Nginx](https://github.com/nginx/nginx) - The world's most popular Web Server, high performance Load Balancer, Reverse Proxy, API Gateway and Content Cache.
- [Envoy](https://github.com/envoyproxy/envoy) - A modern, CNCF backed solution
- [Nginx Proxy Manager (NPM)](https://nginxproxymanager.com/) - A fan favourite in the homelabbing community, a pre-bundled docker image for easy reverse proxying with NGinx. A tradeoff is it is GUI-oriented only. The development pace is not the greatest.
- [NPMPlus](https://github.com/ZoeyVid/NPMplus) - A fork of NPM with lots of new features
- [HAProxy](https://github.com/haproxy/haproxy) - A very fast and reliable reverse-proxy offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
- [SWAG](https://www.linuxserver.io/blog/2020-08-21-introducing-swag) - A bundle from LinuxServer.IO, using Nginx, Php7, Certbot (Let's Encrypt client) and Fail2ban.
- [Zoraxy](https://zoraxy.aroz.org/) - A good alternative for NPM, mainly a GUI reverse Proxy with additional networking features.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
