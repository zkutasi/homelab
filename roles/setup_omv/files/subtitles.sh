#!/usr/bin/env bash

# This script tries to summarize the state of subtitles in every HDD, for Movies
# It expects Hungarian subtitles, with suffix of '.HUN.srt'
# If the Movie has embedded subtitles, mark it with '.srt.inside'
# Requirements:
#    - Setting up the PATHS variable properly, so you end up with a list of your Paths to scan.
# Arguments: NONE

PATHS='/srv/dev-disk-by-label-hdd0{1..7}/Movies/'


function process_path()
{
  local count=0
  local subbed=0
  local nonsubbed=0
  local inside=0
  local path=$1
  local hdd=$2
  while read -r line; do
    local bn=$(basename "${line}")
    local dn=$(dirname "${line}")
    local srtbasename="${line%.*}"
    local substatus=""
    ((count++))
    tobehandled=0
    if [ -f "${srtbasename}.HUN.srt" ]; then
      substatus=SUBBED
      ((subbed++))
    elif [ -f "${srtbasename}.srt.inside" ]; then
      substatus=INSIDE
      ((inside++))
    else
      tobehandled=1
      substatus=SUBMISSING
      ((nonsubbed++))
    fi
    if [ ${tobehandled} -eq 1 ] && [ ${summary} -eq 0 ]; then
      printf "%10s %100s %12s\n" "${hdd}" "${bn}" "${substatus}"
    fi
  done < <(find ${path} -iname '*.mkv' | grep -vi "sample")
  if [ ${summary} -eq 1 ]; then
    printf "%10s %10d %10d %10d %10d\n" "${hdd}" "${count}" "${subbed}" "${inside}" "${nonsubbed}"
  fi
}


summary=1
disk=""
while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--summary)
      summary=1
      shift
      ;;
    -v|--verbose)
      summary=0
      shift
      ;;
    -d|--disk)
      shift
      disk=$1
      shift
      ;;
    *)
      shift
      ;;
  esac
done



if [ ${summary} -eq 1 ]; then
  printf "%10s %10s %10s %10s %10s\n" "HDDNAME" "COUNT" "SUBBED" "INSIDE" "NONSUBBED"
else
  printf "\n"
fi
for path in $(eval echo ${PATHS}); do
  if [ -n ${disk} ] && [[ ${path} == *${disk}* ]]; then
    rowkey=$(echo ${path} | sed 's;.*dev-disk-by-label-\([^/]*\)/.*;\1;')
    process_path "${path}" "${rowkey}"
  fi
done
