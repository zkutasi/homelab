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

### Scrobblers

It is sometimes beneficial to have your listening taste analyzed, by forwarding what music you listen to. This is called scrobbling. The process can be set up in each of the music listening apps/servers. Then the online scrobbler website can list your favourites, lets you explore their catalog, or even recommend to you new similar artists.

If a piece of software only supports the most popular scrobbler, you should use a tool that cross-scrobbles, below are some examples.

- [Last.fm](https://www.last.fm/) - The original that started it all, for music
  - [YourLastFM](https://github.com/Gomaink/your_lastfm) - Turn your Last.fm scrobbles into a complete, private dashboard.
- [ListenBrainz](https://listenbrainz.org) - Part of the *Brainz family
- [Libre.fm](https://libre.fm/) - A more private last.fm alternative
- [Koito](https://koito.io/) - A modern, themeable scrobbler that you can use with any program that scrobbles to a custom ListenBrainz URL
- [Maloja](https://github.com/krateng/maloja) - Simple self-hosted music scrobble database to create personal listening statistics. No commits since early 2025, seems abandoned.
- [MultiScrobbler](https://github.com/FoxxMD/multi-scrobbler) - Scrobble plays from multiple sources to multiple clients

### Companion apps

- [Beets](https://beets.io) - Music library manager and MusicBrainz tagger. Useful to retag files so the media servers show Albums and Compilations right.

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
