#!/bin/bash

function usage() {
    echo "Usage: $0"
    echo ""
    echo "Gives the media folders on the data disks (hdd01-hdd07) and everything in them to qta:users, folders 0750 and files 0640, using sudo. Takes no options."
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

# The data disks; hdd08 is the SnapRAID parity disk
DISKS=$(seq -f "/srv/dev-disk-by-label-hdd%02g" 1 7)
MEDIA="Animation Anime AnimeSeries Docu DocuSeries Movies TVSeries Shorts Excercise OtherMedia"

FOLDERS=$(for DISK in ${DISKS}; do
  for M in ${MEDIA}; do
    [ -d "${DISK}/${M}" ] && echo "${DISK}/${M}"
  done
done)

# Without folders, find would fall back to the current folder
if [ -z "${FOLDERS}" ]; then
  echo "ERROR: none of the media folders exist on the data disks"
  exit 1
fi

echo "Finding files not owned by ${USER}..."
sudo find ${FOLDERS} \! -user ${USER} -print

echo "Fixing the ownerships..."
sudo chown -R ${USER}:${GROUP} ${FOLDERS}
sudo find ${FOLDERS} -type d -exec chmod 0750 {} +
sudo find ${FOLDERS} -type f -exec chmod 0640 {} +

echo "Rechecking..."
sudo find ${FOLDERS} \! -user ${USER} -print

echo "DONE"
