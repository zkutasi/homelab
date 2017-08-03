#!/bin/bash

# This script will start up varroa on a Synology NAS automatically after reboot
# Requirements:
#    - Put it in /usr/local/etc/rc.d
#    - Set it up using the top variables

DIR="/var/services/homes/qta/varroa"
PRG="./varroa"

case "$1" in
start)
    su - qta -c "cd ${DIR}; ${PRG} start"
    ;;
status)
    if [ -f ${DIR}/varroa_pid ] && ps -p $(cat ${DIR}/varroa_pid) &>/dev/null; then
        echo "Running"
    else
        echo "Not Running"
    fi
    ;;
stop)
    su - qta -c "cd ${DIR}; ${PRG} stop"
    ;;
restart)
    su - qta -c "cd ${DIR}; ${PRG} stop"
    su - qta -c "cd ${DIR}; ${PRG} start"
    ;;
*)
    echo "Usage: $0 {status|start|stop|restart}"
    exit 1
esac
