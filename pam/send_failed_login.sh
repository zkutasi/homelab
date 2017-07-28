#!/usr/bin/env bash

# This script when put inside /etc/pam.d/common-auth will send failed login attempts via a push message
# Requirements:
#    - properly set up send_push.sh
#    - Add the following line into /etc/pam.d/common-auth:
#      auth    [default=ignore]                pam_exec.so seteuid /usr/local/bin/send_failed_login.sh
#    - Also increase the success counter to jump over this line also in case of success

if [ "${PAM_TYPE}" == "open_session" ]; then
  message="User ${PAM_USER} from ${PAM_RHOST} tried to log in just now onto host $(hostname) without success"
  /home/qta/send_push.sh "${message}"
fi

exit 0
