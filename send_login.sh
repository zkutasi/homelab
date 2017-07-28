#!/usr/bin/env bash

# This script when put inside /etc/pam.d/sshd will send login attempts via a push message
# Requirements:
#    - properly set up send_push.sh
#    - Add the following line into /etc/pam.d/sshd:
#      session   optional   pam_exec.so /usr/local/bin/send_login.sh

if [ "${PAM_TYPE}" == "open_session" ]; then
  message="User ${PAM_USER} from ${PAM_RHOST} logged in just now onto host $(hostname)"
  /home/qta/send_push.sh "${message}"
fi

exit 0
