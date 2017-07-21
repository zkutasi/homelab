#!/bin/bash

# This script can push a message whenever a torrent is downloaded, and also the free disk space available
# Requirements:
#    - A Torrent client that supports such functionality (like rTorrent)
#    - Create a file pushover.info, with the following format:
#      token=YOURAPITOKEN
#      user=YOURUSERTOKEN
#    - Edit .rtorrent.rc and add the following line at the end
#      method.set_key = event.download.finished,notify_me,"execute=~/push_torrent.sh,$d.name="
#    - Fill in the quota you have
# Arguments:
#    - The torrent name (will come from the client)

source pushover.info

name=$1
QUOTA=1500

message1="Downloaded: ${name}"

occ_space=$(du ${HOME} --si -sh -BG 2>/dev/null | awk '{print $1}' | tr -d -c 0-9)
free_space=$((QUOTA-occ_space))
message2="Free space: ${free_space}GB / ${QUOTA}GB"

curl -s --form-string "token=${token}" \
        --form-string "user=${user}" \
        --form-string "message=${message1}
${message2}" https://api.pushover.net/1/messages.json
