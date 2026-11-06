# Virtualization

In order for one host to better utilize its resources, and provide much better isolation for a homelab setup, some kind of Virtualization is essential. To be able to run more types of OS-es (Linux and Windows), more flavors, test different versions and experiment.

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [VMWare VSphere](https://www.vmware.com/) - Also known as ESXi Originally one of the first good alternatives, lately it went up in price and the components it requires are a bit too much. However it blasts some serious features.
- [Proxmox](https://www.proxmox.com/) - The most versatile Virtualization Environment for homelabs
- [XCP-ng](https://xcp-ng.org/) - A solution based on XenServer from Citrix
- [TrueNAS](https://www.truenas.com/) - A Specific OS for NAS workloads
- [Hyper-V](https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/hyper-v-technology-overview) - From Microsoft, for Windows machines as hosts mostly
- [KVM](https://linux-kvm.org/page/Main_Page) - Vanilla Linux VMs in the Kernel, but does not have a GUI, so a steep learning curve
- [VirtualBox](https://www.virtualbox.org/) - From Oracle

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
