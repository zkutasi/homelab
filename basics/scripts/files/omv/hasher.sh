#!/bin/bash

# This script creates a sha1 hash next to all of the movie files, if there is none already
# Requirements:
#    - A sane and simple naming convention for the drives:
#      > Labelled for example hddXX, where XX goes 01,02,03,...
#      > Mounted by label with a sane naming convention
#    - Setting up the drive_dir, drives variables properly, so you end up with a list of your required drives
#      Of course if you have mounts and labels all around the place, give them manually
#    - A sane directory structure, same on every HDD (Movies, Animation, Anime, Docu, etc...)
# Arguments: If a specific subfolder needs to be traversed, that folder, otherwise we traverse the whole host

function hash_all_mkv_files()
{
  path="$1"
  i=1
  num=$(find "${path}" -type f -name '*.mkv' | wc -l)
  while IFS= read -r file; do
    if [ -n "${file}" ]; then
      if [ ! -s "${file}.sha" ]; then
        filename=$(basename "${file}")
        dirname=$(dirname "${file}")
        echo "[${i}/${num}] Creating SHA hash for ${file}..."
        pushd "${dirname}" > /dev/null 2>&1
        sha1sum "${filename}" > "${filename}.sha"
        popd > /dev/null 2>&1
      else
        echo "[${i}/${num}] ${file} already has a SHA hash"
      fi
    fi
    ((i++))
  done < <(find "${path}" -type f -name '*.mkv')
}

if [ "$1" = "--help" ]; then
  echo "Usage: $0 [<folder>]"
  echo ""
  echo "Writes a sha1 hash next to every .mkv without one, in <folder> or on all disks."
  exit 0
fi

if [ $# -gt 1 ]; then
  echo "ERROR: Too many arguments!"
  exit 1
elif [ $# -eq 1 ]; then
  hash_all_mkv_files "$1"
else
  echo "Traversing all the disks..."
  drive_dir="/srv/dev-disk-by-label-hdd0"
  drives=$(seq -w 1 7 | sed "s,^,${drive_dir},")

  for drive in ${drives}; do
    echo "Handling drive ${drive}..."
    for type in Animation Anime Docu Movies AnimeSeries DocuSeries TVSeries; do
      hash_all_mkv_files "${drive}/${type}"
    done
  done
fi
