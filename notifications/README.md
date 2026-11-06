# Notifications

It is great if things go well, but if not, one wants to get notified about any issues. Or any notable event happening. This is where notification systems come into the picture. Some use their own App, some is able to aggregate the messages and send them into many different endpoints (email, discord, slack, etc)

## Requirements

- Free and Open source, preferably 0$ cost

## Contenders

- [Pushover](https://pushover.net/) - Pushover makes it easy to get real-time notifications on your Android, iPhone, iPad, and Desktop (Android Wear and Apple Watch, too!). 5 USD one time purchase.
- [Ntfy](https://ntfy.sh/) - Send push notifications to your phone or desktop using PUT/POST
- [Gotify](https://gotify.net/) - A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)
- [Apprise](https://appriseit.com/) - Push Notifications that work with just about every platform!
  - [Mailrise](https://mailrise.xyz/) - An SMTP gateway for Apprise notifications. Lets legacy apps that can only send email take part in the Apprise pipeline.

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |apprise_api_hostname|M|The Apprise API hostname to configure the notification architecture with|
    |apprise_target_key|M|The apprise endpoint that identifies the configuration to use for the whole notification pipeline|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |gotify_token|O|The app token for Gotify to identify the host in the notifications|
    |pushover_token|O|The app token for Pushover to identify the host in the notifications|
