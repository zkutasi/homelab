#!/usr/bin/env python

# Switch On or Off a Yamaha AV Receiver by sending a prepared SOAP message to it
# Requirements
#   - Set the receiver hostname or IP
# Parameters:
#   - on/off

import sys
import socket
import requests

host = 'yamaha'
host = socket.gethostbyname(host)

template_request = u'''<?xml version="1.0" encoding="utf-8"?>
                         <YAMAHA_AV cmd="PUT">
                           <Main_Zone>
                             <Power_Control>
                               <Power>%s</Power>
                             </Power_Control>
                           </Main_Zone>
                         </YAMAHA_AV>'''

on_request = template_request % 'On'
off_request = template_request % 'Standby'

command = ''
if len(sys.argv) > 1:
    command = sys.argv[1]
if len(command) == 0:
    command = 'on'

if command == 'on':
    encoded_request = on_request.encode('utf-8')
else:
    encoded_request = off_request.encode('utf-8')

headers = {
            "Host": host,
            "Content-Type": "text/xml; charset=UTF-8",
            "Content-Length": str(len(encoded_request))
          }

response = requests.post(url="http://%s/YamahaRemoteControl/ctrl" % host,
                         headers = headers,
                         data = encoded_request,
                         verify=False)

