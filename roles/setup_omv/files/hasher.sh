#!/usr/bin/env bash

# This script creates a sha1 hash next to all of the movie files, if there is none already
# Requirements:
#    - A sane and simple naming convention for the drives:
#      > Labelled for example hddXX, where XX goes 01,02,03,...
#      > Mounted by label with a sane naming convention
#    - Setting up the DRIVE_DIR, DRIVES and LABELS variables properly, so you end up with a list of your drives and labels
#      Of course if you have mounts and labels all around the place, give them manually
#    - A sane directory structure, same on every HDD (Movies, Animation, Anime, Docu, etc...)
# Arguments: NONE

DRIVE_DIR="/srv/dev-disk-by-label-hdd0"
DRIVES=$(seq -w 1 7 | sed "s,^,${DRIVE_DIR},")

for drive in ${DRIVES}; do
  for type in Animation Anime Docu Movies AnimeSeries DocuSeries TVSeries; do
    while IFS= read -r file; do
      if [ -n "$file" ]; then
        if [ ! -s "${file}.sha" ]; then
          filename=$(basename "${file}")
	  dirname=$(dirname "${file}")
          echo "Creating SHA hash for ${file}..."
          pushd "${dirname}" 2>&1 > /dev/null
          sha1sum "${filename}" > "${filename}.sha"
          popd 2>&1 > /dev/null
#        else
#  	echo "${file} already has a SHA hash"
        fi
      fi
    done <<< $(find ${drive}/${type} -type f -name '*.mkv')
  done
done
