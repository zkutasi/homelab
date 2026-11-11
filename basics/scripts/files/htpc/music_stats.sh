#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Counts the albums and EPs per release year under /mnt/Music. Takes no options."
}

while [ $# -ge 1 ]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown parameter \"$1\""
      usage
      exit 1
      ;;
  esac
  shift
done

BASE="/mnt/Music/"

for d in Albums EPs; do
  dd="${BASE}/$d"
  echo "Directory ${dd}"
  find ${dd}  -maxdepth 1 | egrep -o "\([[:digit:]]{4} - .*\)$|\([[:digit:]]{4}\)" | sed 's/(//' | cut -c1-4 | sort | uniq -c
done
