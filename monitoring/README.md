# Monitoring solutions

Monitoring the Home infrastructure is essential, checking high CPU usage, error logs or SMART data for failure detection, but also to see if anything needs updating. And much more...

## Requirements

- Free and Open source, preferably 0$ cost
- Cloud Native, with collectors possible to be installed anywhere (preferably in docker too)
- Able to visualize anything, in a highly customizable way
- Collect logs from the host and from containers too
- Collect metrics from the hosts and from containers too
- Collect any additional data specific for a unique use-case
  - HDD and SSD/NVME SMART info
  - Power consumption
  - UPS info
- Collect running container and helm chart versions and notify about updates

### What to collect

- Logs (from the Host and from Docker containers too)
- Performance and other metrics
- SMART data
- UPS (NUT) data

## Contenders

### All in one solutions

These solutions are very easy to deploy, extensive, but has many limitations and customizing them is not that easy. Figuring out how to add some exytra metrics is harder as they might be not that widely used or even proprietarily managed.

Some more popular examples are:

- [LibreNMS](https://www.librenms.org/) - Community-based GPL-licensed network monitoring system
- [CheckMK](https://checkmk.com/) - An all-in-one solution with an agent-based approach. The agents are super-flexible and programmable. The tool can collect a lot of metrics by default, has sensible warnings on them and quite extensible. Though the configuration of it might be a nightmare due to the conplexity.
- [Netdata](https://www.netdata.cloud/) - Also an all-in-one solution focusing on near-real-time metrics collection. Also agent based, and very flexible. The company focuses on Cloud data-storage for the tool but self-hosting is also possible.
- [Paessler PRTG](https://www.paessler.com/prtg) -A very nice solution with a huge drawback: The dashboard is Windows only.
- [Zabbix](https://www.zabbix.com/index)
- [Beszel](https://beszel.dev/) - Lightweight server monitoring with historical data, docker stats, and alerts.
- [Glances](https://github.com/nicolargo/glances) - Glances an Eye on your system. A top/htop alternative for GNU/Linux, BSD, macOS and Windows operating systems.
- [Pulse](https://github.com/rcourtman/Pulse) - Monitoring for Proxmox, Docker, Kubernetes, TrueNAS, and vSphere that watches your infrastructure for you: smart alerts, AI patrols that catch silent failures, and verified fixes

### Grafana LGTM+ stack

This stack is all from Grafana Labs, and consists of the following components:

- [Loki](https://grafana.com/oss/loki/) for Logs
- [Grafana](https://grafana.com/) for Visualization
- [Tempo](https://grafana.com/oss/tempo/) for Traces
- [Mimir](https://grafana.com/oss/mimir/) for Metrics
- [Pyroscope](https://grafana.com/docs/pyroscope/latest/) for Profiles

Can be all deployed using the `k8s-monitoring-helm` helm chart.

### Data collection

- [Alloy](https://grafana.com/docs/alloy/latest/) - Grafana Alloy combines the strengths of the leading collectors into one place. Whether observing applications, infrastructure, or both, Grafana Alloy can collect, process, and export telemetry signals to scale and future-proof your observability approach.
- [Open Telemetry Collector](https://opentelemetry.io/docs/collector/) - This is the original source of Alloy itself
- [Promtail](https://grafana.com/docs/loki/latest/send-data/promtail/) - The discontinued log collector from Grafana Labs
- [Vector](https://vector.dev/) - By Datadog
- [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) - From InfluxDB
- There are a vast amount of different exporters for different purposes, common or niche.

### Visualization

- [Grafana](https://grafana.com/) - Seems to be the de-facto standard visualizer, capable of reading from many dozens of sources. Integrates well with many things.
- [Kibana](https://www.elastic.co/kibana) - The ELK Log visualization, [more info here](https://last9.io/blog/kibana-vs-grafana/)

### Metrics

- [Prometheus](https://prometheus.io/) - The de-facto standard Time Series Database (TSDB), oldest solution that is able to read metrics from services calling an endpoint on them that provides text-based data. A couple of other options can be found [on the official site](https://prometheus.io/docs/introduction/comparison/)
- [VictoriaMetrics](https://victoriametrics.com/products/open-source/) - A fork of Prometheus, with lots of optimizations, [more info here](https://last9.io/blog/prometheus-vs-victoriametrics/)
- [Mimir](https://grafana.com/oss/mimir/) - Grafana Labs' solution from their own stack
- [Thanos](https://thanos.io/) - Extends Prometheus with long-term storage, HA and more features, [more info here](https://last9.io/blog/prometheus-vs-thanos/)
- [Cortex](https://cortexmetrics.io/) - Another long-term storage for metrics, [more info here](https://last9.io/blog/prometheus-vs-cortex/)
- [InfluxDB](https://www.influxdata.com/) - Scalable datastore for metrics, events, and real-time analytics
- [Graphite](https://graphiteapp.org/) - Another TSDB Database, [more info here](https://last9.io/blog/graphite-vs-prometheus/)

It is also important to see if the metrics collection is push or pull. Prometheus usually pulls the metrics while for example InfluxDB one needs to push metrics into it somehow.

### Logs

- [Loki](https://grafana.com/oss/loki/) - Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.
- [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/) - Sister of VictoriaMetrics, focusing on footprint reduction and performance improvements
- [GrayLog](https://graylog.org/) - A popular alternative among homelabbers, [more info here](https://last9.io/blog/graylog-vs-loki/)
- [ELK Stack](https://www.elastic.co/elastic-stack) - The ELK stack, [more info here](https://last9.io/blog/kibana-vs-grafana/)
- [Dozzle](https://dozzle.dev/) - A tool to help visualize all container logs in a WebUI. Supports multiple remote Hosts too.
- [Loggifly](https://clemcer.github.io/LoggiFly/) - Get Alerts from your Docker Container Logs

### Tracing

Allows to show across microservices the end-to-end flow of data, and catch the root cause of bugs.

- [Jaeger](https://www.jaegertracing.io/) - From Uber
- [Zipkin](https://zipkin.io/) - From Twitter, [more info here](https://last9.io/blog/jaeger-vs-zipkin/)
- [Tempo](https://grafana.com/oss/tempo/) - The Grafana Labs contender, [more info here](https://last9.io/blog/grafana-tempo-vs-jaeger/)

### Updates & Patches

Linux has to be up-to-date, these tools make it obvious if they are lacking behind.

- [PatchMon](https://patchmon.net/) - Linux Patch Management & Automation Platform
- [Linux Update Dashboard](https://github.com/TheDuffman85/linux-update-dashboard) - Web app for managing Linux package updates across multiple servers. Connect via SSH, check for updates, and apply them from a single dashboard in your browser. No agents are required.

### Special ones

- [NetAlertX](https://netalertx.com/) - Centralized network visibility and continuous asset discovery. Monitor devices, detect change, and stay aware across distributed networks.
- [Scrutiny](https://github.com/analogj/scrutiny/pkgs/container/scrutiny) - A S.M.A.R.T. checker, that also correlates data from BackBlaze to predict HDD issues. Project seems to be abandoned on the release-side, but the images are updated regularly. Pretty interesting metrics, although extremely unreliable.

## Notable comments

- To properly have per-container cgroup reported memory, one needs to edit the file `/boot/firmware/cmdline.txt` and add `cgroup_memory=1 cgroup_enable=memory` to enable this feature.
