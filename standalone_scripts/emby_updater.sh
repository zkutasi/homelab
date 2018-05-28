#!/bin/bash

#
# Emby update script
# by Philip "ShokiNN'" Henning <mail@philip-henning.com>
#
# License: MIT
# Copyright 2018 Philip Henning
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Check if script runs as root
if [ $UID != 0 ]; then
	echo "You have to run this script as root or with sudo."
	exit 1
fi

# Check if Emby is installed, and when yes compare versions.
if [[ $(dpkg-query -W --showformat='${Status}\n' emby-server 2> /dev/null | grep "install ok installed") == "" ]]; then
	read -p "Do you want to install Emby? (Y/N): " install_emby
	while true; do
		case $install_emby in
			[Yy]*)
				break
				;;
			[Nn]*)
				exit 0
				;;
			*)
				echo "Please answer yes or no."
				;;
		esac
	done
elif [[ $(dpkg-query -W --showformat='${Status}\n' emby-server 2> /dev/null | grep "install ok installed") = "install ok installed" ]]; then
	# Get installed version number
	lcl_emby_version=$(dpkg -l emby-server | grep ^ii | awk '{split($0,a," "); print a[3]}')
	# Get stable release version number
	rmt_emby_version=$(curl -s https://api.github.com/repos/MediaBrowser/Emby/releases/latest | grep "browser_download_url.*emby-server-deb.*amd64" | cut -d : -f 2,3 | tr -d \" | awk '{split($0,a,"/"); print a[8]}')
	# Check if version numbers differs
	if [ "$lcl_emby_version" != "$rmt_emby_version" ]; then
		echo "You local version number differs from the latest Emby version:"
		echo "Local Emby Version:  $lcl_emby_version"
		echo "Remote Emby Version: $rmt_emby_version"
		read -p "Do you want to update Emby? (Y/N): " update_emby
		while true; do
			case $update_emby in
				[Yy]*)
					break
					;;
				[Nn]*)
					exit 0
					;;
				*)
					echo "Please answer yes or no."
					;;
			esac
		done
	fi
fi

# Delete dir if exists
if [ -d /tmp/emby-update ]; then
	rm -rf /tmp/emby-update
fi

# Check if download folder exists
if [ ! -d /tmp/emby-update ]; then
	mkdir /tmp/emby-update
fi

# Change to the download directory
cd /tmp/emby-update

# Download the latest stable release
curl -s https://api.github.com/repos/MediaBrowser/Emby/releases/latest \
| grep "browser_download_url.*emby-server-deb.*amd64" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

# Check if emby is running
if [ $(systemctl is-active emby-server.service) == "active" ]; then
	while true; do
		read -p "Do you want to stop the Emby server and install the update? (Y/N): " install_update
		case $install_update in
			[Yy]*)
				systemctl stop emby-server.service
				break
				;;
			[Nn]*)
				cd ..
				rm -rf ./emby-update
				exit 0
				;;
			*)
				echo "Please answer yes or no."
				;;
		esac
	done
fi

# Install emby
dpkg -i emby-server-deb_*_amd64.deb
systemctl start emby-server.service
cd ..
rm -rf ./emby-update

exit 0
