FROM debian:12@sha256:268fb24c39bca92d326dd83ea3abebe4a3f7751c804ffef23bb6d857dd343ff8
RUN apt-get update \
 && apt-get install -y --no-install-recommends systemd systemd-sysv python3 python3-apt gnupg sudo unzip p7zip-full \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
