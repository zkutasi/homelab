#!/bin/bash

# This script tries to quickly parse the NAS's given HDDs, given directories
# and counts how many unique media-elements there are (movies, episodes, etc...)
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



FILTER="sample"

echo "Singles:"
printf "%5s %10s %10s %10s %10s\n" "DRIVE" "ANIMATION" "ANIME" "DOCU" "MOVIE"

declare -A number
declare -A sum
for drive in ${DRIVES}; do
  for type in Animation Anime Docu Movies; do
    number[${type}]=$(find ${drive}/${type} -type f -name '*.mkv' | grep -vi "${FILTER}" | wc -l)
    sum[${type}]=$((sum[${type}] + number[${type}]))
  done

  label=$(echo ${drive} | sed 's/.*-by-label-//')
  printf "%5s %10d %10d %10d %10d\n" "${label}" ${number[Animation]} ${number[Anime]} ${number[Docu]} ${number[Movies]}
done

printf "%5s %10d %10d %10d %10d\n" "SUM" ${sum[Animation]} ${sum[Anime]} ${sum[Docu]} ${sum[Movies]}


echo


echo "Series:"
printf "%5s %10s %10s %10s\n" "DRIVE" "ANIME" "DOCU" "TV"

declare -A number_s
declare -A sum_s
for drive in ${DRIVES}; do
  for type in AnimeSeries DocuSeries TVSeries; do
    number_s[${type}]=$(find ${drive}/${type} -mindepth 1 -maxdepth 1 -type d | wc -l)
    sum_s[${type}]=$((sum_s[${type}] + number_s[${type}]))
  done

  label=$(echo ${drive} | sed 's/.*-by-label-//')
  printf "%5s %10d %10d %10d\n" "${label}" ${number_s[AnimeSeries]} ${number_s[DocuSeries]} ${number_s[TVSeries]}
done

printf "%5s %10d %10d %10d\n" "SUM" ${sum_s[AnimeSeries]} ${sum_s[DocuSeries]} ${sum_s[TVSeries]}
