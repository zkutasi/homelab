# Music

Music collection servers and streamers, to listen to the own music library from any browser or device.

## Requirements

- Free and Open source, preferably 0$ cost
- Metadata building from online sources
- Scrobbling support
- Extensive filtering capabilities

## Contenders

- [Navidrome](https://www.navidrome.org/) - An open source web-based music collection server and streamer. It gives you freedom to listen to your music collection from any browser or mobile device. It's like your personal Spotify!
- [Koel](https://koel.dev/) - A simple web-based personal audio streaming service written in Vue on the client side and Laravel on the server side. Targeting web developers, Koel embraces some of the more modern web technologies to do its job.
- [Swing Music](https://swingmx.com/) - A fast and beautiful, self-hosted music player for your local audio files. Like a cooler Spotify ... but bring your own music. Just run the app and enjoy your music library in a web browser.
- [Lightweight Music Server (LMS)](https://github.com/epoupon/lms) - A self-hosted music streaming software: access your music collection from anywhere using a web interface!
- [Gonic](https://github.com/sentriz/gonic) - Free-software subsonic server API implementation, supporting its many clients
- [Ampache](https://ampache.org/) - A web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device.
- *Sonic - A free, web-based media streamer platform with a specific API. [SubSonic](https://www.subsonic.org) was the original (this went closed source), then LibreSonic was forked, after that [Airsonic](https://github.com/airsonic/airsonic) (abandoned since 2020) and [Airsonic-advanced](https://github.com/airsonic-advanced/airsonic-advanced) (again abandoned since 2020)

## Usage

### Ansible inventory setup

Variables that are shared more widely than this group of Apps are not listed here, but in the more generic README files higher up in the folder structure. Only the variables shared by the Apps of this group are listed below.

1. Add the following variables into the `all` group_vars file:

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|

2. For each Ansible host, the following variables can be set

    |Name|Mandatory/Optional|Details|
    |----|------------------|-------|
    |music_mounts|O|The folders to mount into the container for music|
    |music_mounts.from|M|The folder on the host|
    |music_mounts.to|M|Where the folder appears inside the container|
