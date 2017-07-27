#!/usr/bin/env bash

# This script will send a push message over pushover
# Requirements:
#    - Create a file pushover.info, with the following format:
#      token=YOURAPITOKEN
#      user=YOURUSERTOKEN
# Arguments:
#    1 - The message itself

source /root/pushover.info

message="$1"
CURL=/usr/local/bin/curl

${CURL} -s \
  --form-string "token=${token}" \
  --form-string "user=${user}" \
  --form-string "message=${message}" \
  https://api.pushover.net/1/messages.json
