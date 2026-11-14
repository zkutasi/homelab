#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Gives every file under /export to qta:users with mode 777, using sudo. Takes no options."
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

USER=qta
GROUP=users

ROOT=/export

echo "Finding files not owned by ${USER}..."
sudo find ${ROOT} \! -user ${USER} -print

echo "Fixing the ownerships..."
sudo chown -R ${USER}:${GROUP} ${ROOT}/*/*
sudo find ${ROOT}/*/* -type d -exec chmod 0750 {} +
sudo find ${ROOT}/*/* -type f -exec chmod 0640 {} +

echo "Rechecking..."
sudo find ${ROOT} \! -user ${USER} -print

echo "DONE"
