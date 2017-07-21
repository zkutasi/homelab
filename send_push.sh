#!/usr/local/bin/bash

source pushover.info

message="$1"

curl -s \
  --form-string "token=${token}" \
  --form-string "user=${user}" \
  --form-string "message=${message}" \
  https://api.pushover.net/1/messages.json
