#!/usr/bin/env bash

# This script will use ntopng and parses its RRD structure to get information about the monthly traffic usage every day.
# The information is provided per host, up/down/total, with special attention to the last 24 hours
# Requirements
#    - works on BSD, on pfSense
#    - ntopng is installed in pfsense (with default config about RRD)
#    - local DNS server is up and running with DHCP host-based registration
#    - script is parameterized corretly:
#      > INTERFACE number must be the LAN interface
#      > HOSTS are the LAN hosts you are interested in

INTERFACE=0
HOSTS="ubuntu omv synology216 torrents"



NTOPNG_DIR=/var/db/ntopng
RRDTOOL=/usr/local/bin/rrdtool
AWK=/usr/bin/awk
BC=/usr/bin/bc
SED=/usr/bin/sed
DATE=/bin/date
DIG=/usr/local/bin/dig
CURL=/usr/local/bin/curl

sum_total_up_gb=0
sum_total_down_gb=0
sum_total_gb=0

total_up=0
total_down=0
function get_info()
{
  local host=$1
  local start=$2

  while read -r line; do
    local date=$(echo ${line} | ${AWK} '{print $1}' | ${SED} 's/:$//')
    [[ ! "${date}" =~ [0-9]+ ]] && continue

    local up=$(echo ${line} | ${AWK} '{print $2}')
    up=$(printf "%f" "${up}")

    local down=$(echo ${line} | ${AWK} '{print $3}')
    down=$(printf "%f" "${down}")

    if [ "${up}" == "nan" ] || [[ "${up}" == -* ]]; then
      up=0
    fi

    if [ "${down}" == "nan" ] || [[ "${down}" == -* ]]; then
      down=0
    fi

    [ "${up}" == "0" ] && [ "${down}" == "0" ] && continue

    up=$(echo "${up} * ${resolution}" | ${BC})
    down=$(echo "${down} * ${resolution}" | ${BC})

#    echo "DATE: $(${DATE} -j -f %s ${date})"
#    echo "UP  : ${up}"
#    echo "DOWN: ${down}"

    total_up=$(echo "${total_up} + ${up}" | ${BC})
    total_down=$(echo "${total_down} + ${down}" | ${BC})

  done < <(${RRDTOOL} fetch ${NTOPNG_DIR}/${INTERFACE}/rrd/${host}/bytes.rrd AVERAGE --start ${start} --resolution ${resolution})
}

function get_total_up_for_host()
{
  local host=$1
  full_host=$(${DIG} ${host}.local | grep "ANSWER" -A 1 | tail -1 | ${AWK} '{print $NF}' | tr '.' '/')
  local start=$2
  local resolution=$3
  total_up=0
  total_down=0
  local total=0
  get_info "${full_host}" "${start}"

  # Calculating the GByte formats
  local total_up_gb=$(echo "${total_up} /1024.0/1024.0/1024.0" | ${BC} -l)
  local total_down_gb=$(echo "${total_down} /1024.0/1024.0/1024.0" | ${BC} -l)

  total=$(echo ${total_up} + ${total_down} | ${BC})
  local total_gb=$(echo "${total} /1024.0/1024.0/1024.0" | ${BC} -l)

  # Calculating difference from previous day
  total_up=0
  total_down=0
  get_info "${full_host}" "-24hour"
  total_up_gb_diff=$(echo "${total_up} /1024.0/1024.0/1024.0" | ${BC} -l)
  if [[ ! "${total_up_gb_diff}" =~ ^[.0].*$ ]]; then
    total_up_gb_diff=$(printf "%4.0f" "${total_up_gb_diff}")
    total_up_gb_diff="(+${total_up_gb_diff})"
  else
    total_up_gb_diff=""
  fi
  total_down_gb_diff=$(echo "${total_down} /1024.0/1024.0/1024.0" | ${BC} -l)
  if [[ ! "${total_down_gb_diff}" =~ ^[.0].*$ ]]; then
    total_down_gb_diff=$(printf "%4.0f" "${total_down_gb_diff}")
    total_down_gb_diff="(+${total_down_gb_diff})"
  else
    total_down_gb_diff=""
  fi

  printf "%12s %6.2fGB %7s %6.2fGB %7s %6.2fGB %7s\n" "${host}" "${total_up_gb}" "${total_up_gb_diff}" "${total_down_gb}" "${total_down_gb_diff}" "${total_gb}" "${total_gb_diff}"

  # Calculating Sum totals
  sum_total_up_gb=$(echo ${sum_total_up_gb} + ${total_up_gb} | ${BC})
  sum_total_down_gb=$(echo ${sum_total_down_gb} + ${total_down_gb} | ${BC})
  sum_total_gb=$(echo ${sum_total_gb} + ${total_gb} | ${BC})

}


days=$(${DATE} +%d)
((days--))
ip=$(${CURL} -s ipinfo.io/ip)
echo "Getting monthly traffic data based on ${days} days for ${ip}"
printf "%12s %8s %7s %8s %7s %8s %7s\n" "HOST" "UP" "" "DOWN" "" "TOTAL" ""
for host in ${HOSTS}; do
  get_total_up_for_host ${host} "-${days}day" "3600"
done
printf "%12s %6.2fGB %7s %6.2fGB %7s %6.2fGB %7s\n" "SUM" "${sum_total_up_gb}" "" "${sum_total_down_gb}" "" "${sum_total_gb}" ""

