# eBPF tools

[eBPF](https://ebpf.io/) allows sandboxed programs to run within the operating system, which means that application developers can run eBPF programs to add additional capabilities to the operating system at runtime. The operating system then guarantees safety and execution efficiency as if natively compiled with the aid of a Just-In-Time (JIT) compiler and verification engine. This has led to a wave of eBPF-based projects covering a wide array of use cases, including next-generation networking, observability, and security functionality.

## Requirements

- Free and Open source, preferably 0$ cost
- Possibility to deploy its Agent to any Linux VM, possibly both in docker or as a service, and into Kubernetes as a DaemonSet

## Contenders

### Kubernetes only

- [Cilium](https://cilium.io/)
  - with [Hubble](https://github.com/cilium/hubble) - Network, Service & Security Observability for Kubernetes using eBPF
- [Calico](https://www.tigera.io/project-calico/) with Whisker
- [Kubeshark](https://kubeshark.com/) - eBPF-powered network observability for Kubernetes. Indexes L4/L7 traffic with full K8s context, decrypts TLS without keys. Queryable by AI agents via MCP and humans via dashboard.
- [Pixie](https://px.dev/) - Instant Kubernetes-Native Application Observability
- [Caretta](https://github.com/groundcover-com/caretta) - Instant K8s service dependency map, right to your Grafana.
- [Retina](https://retina.sh/) - eBPF distributed networking observability tool for Kubernetes

### CLI Tools

- [bpftop](https://bpftop.sh/) - bpftop provides a dynamic real-time view of running eBPF programs. It displays the average runtime, events per second, and estimated total CPU % for each program.
- [Inspektor Gadget](https://www.inspektor-gadget.io/) - A set of tools and framework for data collection and system inspection on Kubernetes clusters and Linux hosts using eBPF
- [Tetragon](https://tetragon.io/) - eBPF-based Security Observability and Runtime Enforcement
- [Oryx](https://github.com/pythops/oryx) - TUI for sniffing network traffic using eBPF on Linux
- [Kyanos](https://kyanos.io/) - A networking analysis tool using eBPF. It can visualize the time packets spend in the kernel, capture requests/responses, makes troubleshooting more efficient.

### Heterogenous network compatible

- [Falco](https://falco.org/) - Cloud Native Runtime Security
- The Grafana ecosystem with [Beyla](https://grafana.com/oss/beyla-ebpf/) - eBPF-based autoinstrumentation of web applications and network metrics
- [Parca](https://parca.dev/) - Continuous profiling for analysis of CPU and memory usage, down to the line number and throughout time. Saving infrastructure cost, improving performance, and increasing reliability.
- [Coroot](https://coroot.com/) - An open-source observability and APM tool with AI-powered Root Cause Analysis. It combines metrics, logs, traces, continuous profiling, and SLO-based alerting with predefined dashboards and inspections.
- [Cloudflare eBPF Exporter](https://github.com/cloudflare/ebpf_exporter) - Prometheus exporter for custom eBPF metrics
- [NetObserv](https://netobserv.io/) - A Kubernetes operator for network observability.
  - Also has a Linux installable [eBPF agent](https://github.com/netobserv/netobserv-ebpf-agent)
- [Deepflow](https://deepflow.io/) - eBPF Observability - Distributed Tracing and Profiling
