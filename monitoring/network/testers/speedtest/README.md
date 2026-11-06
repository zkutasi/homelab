# Speedtest trackers

Applications, that periodically or on-demand measure the internet speed, and record it.

## Requirements

- Free and Open source, preferably 0$ cost
- Periodically measure the speed, latency and potentially more
- Draw graphs or provide Prometheus metrics (or both)

## Contenders

- [Librespeed](https://librespeed.org/)
- [MySpeed](https://github.com/gnmyt/MySpeed)
- [OpenSpeedTest](https://openspeedtest.com/)
- [SpeedTest Tracker](https://docs.speedtest-tracker.dev/) - A beautiful solution with its own graphing

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
