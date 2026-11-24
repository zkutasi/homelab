FROM ubuntu:24.04 AS base
RUN apt-get update \
 && apt-get install -y --no-install-recommends systemd systemd-sysv python3 python3-apt gnupg sudo unzip p7zip-full openssh-client dnsmasq-base pipx \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
# pipx the way the hosts get it (basics/setup-python.yaml): Ubuntu's, then a current one installed by pipx itself
# into ~/.local/bin, as Ubuntu's is too old for version pins
RUN python3 -m venv /tmp/bootstrap \
 && /tmp/bootstrap/bin/pip install --no-cache-dir pipx \
 && /tmp/bootstrap/bin/pipx install pipx \
 && rm -rf /tmp/bootstrap /root/.cache
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]

# The docker-compose scenarios: Docker from its own repository like on the hosts, busybox for an offline test image
FROM base AS docker
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && . /etc/os-release \
 && install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL "https://download.docker.com/linux/${ID}/gpg" -o /etc/apt/keyrings/docker.asc \
 && echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y docker-ce busybox-static \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
