#!/bin/bash

# This script checks all of the directories against a deluge torrent client, and shows
# if a particular torrent is not added with the specific content, so it can be added later manually
# Requirements:
#    - Deluge is installed with console access
#    - Fill in parameters at the top
# Arguments: NONE

HOST=127.0.0.1
PORT=
USER=""
PASSWD=""
DISK_PATH="/mnt/Movies-hdd0"
DISKS=$(seq -w 1 7 | sed "s,^,${DISK_PATH},")



function check_deluge_for_file()
{
  local input=$1
  local cmd="connect ${HOST}:${PORT} ${USER} ${PASSWD}; info \"${input}\""
  local name=$(deluge-console "${cmd}" | grep "^Name:" | awk '{print $2}')
  if [ -n "${name}" ]; then
    local a=0
    echo "OK   ${input}"
  else
    echo "---> ${input}"
  fi
}



for d in ${DISKS}; do
  echo "Not found elements on ${d}:"
  while read -r line; do
    check_deluge_for_file "$(basename "${line}")"
  done < <(find ${d} -mindepth 1 -maxdepth 1 -type f -name '*.mkv')
  while read -r line; do
    check_deluge_for_file "$(basename "${line}")"
  done < <(find ${d} -mindepth 1 -maxdepth 1 -type d)
done

