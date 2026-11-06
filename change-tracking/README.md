# Change tracking

A set of tools to track changes on a website, like availability, price, discounts, or anything related to keeping an eye of a piece of HTTP endpoint.

## Requirements

- Free and Open source, preferably 0$ cost
- Notification capabilities, preferably Apprise

## Contenders

- [ChangeDetection.io](https://changedetection.io/) - Best and simplest tool for website change detection, web page monitoring, and website change alerts. Perfect for tracking content changes, price drops, restock alerts, and website defacement monitoring
- [PriceGhost](https://github.com/clucraft/PriceGhost) - A self-hosted price tracking application that monitors product prices from any website.
- [PriceBuddy](https://pricebuddy.jez.me/) - A self hostable app that tracks prices and sends you notifications when prices match your preferences

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
