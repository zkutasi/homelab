# Beets

[Beets](https://beets.io/) is a music metadata tool, to download, fix and rewrite tags in music files, download coverart and more.

## The setup

Beets runs in a docker container and is configured specifically to modify existing files: it does not move or copy, like the usual process advises. Used mainly for retagging purposes, when the tags are not suitable for Emby to represent the Album or Compilation just right.

The used plugins are:

- Deezer - Deezer API for tagging
- Discogs - Discogs API for tagging
- Edit - Edit tags with a text editor
- FromFilename - Tag based on the filename
- Info - A new command to get information of tags in the files themselves
- Spotify - Spotify API for tagging
- Unimported - A new command to list unimported files
- Web - Used only because the used docker image requires it

## Prerequisites

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |discogs_user_token|M|The API token to query Discogs|

2. For Music NAS host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|
    |beets_music_folder|M|The source folder of all the Music on the host that contains them|

### Deploy the app

```bash
./common-ansible-run-playbook.sh --playbook media/beets/deploy-beets.yaml --no-check
```

## Commands

Import some new music:

```bash
docker exec -ti beets beet import FOLDER_TO_IMPORT
```

## Notable comments

- Some plugins were dropped from usage
  - beatport - It does not seem to work, as a new V4 API was created and the code still uses the V3
  - fetchart - Seems versatile, but I want full control which picture is downloaded and when
