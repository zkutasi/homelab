#!/bin/bash

BASE="/mnt/Music/"

for d in Albums EPs; do
  dd="${BASE}/$d"
  echo "Directory ${dd}"
  find ${dd}  -maxdepth 1 | egrep -o "\([[:digit:]]{4} - .*\)$|\([[:digit:]]{4}\)" | sed 's/(//' | cut -c1-4 | sort | uniq -c
done
