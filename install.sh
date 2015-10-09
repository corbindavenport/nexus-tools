#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash

ADB="/usr/local/bin/adb"
FASTBOOT="/usr/local/bin/fastboot"
UDEV="/etc/udev/rules.d/51-android.rules"
OS=$(uname)
ARCH=$(uname -m)

XCODE=0

BASEURL="https://github.com/corbindavenport/nexus-tools/raw/master"

_install() {
	sudo curl -Lfks -o "$1" "$2" && echo "[INFO] Success." || { echo "[EROR] Download failed."; XCODE=1; }
}

_install_udev() {
    if [ -n "$UDEV" ] && [ "$OS" == "Linux" ]; then
        if [ ! -d /etc/udev/rules.d/ ]; then
            sudo mkdir -p /etc/udev/rules.d/
        fi

	local install=1

	if [ -f "$UDEV" ]; then
		echo "[WARN] Udev rules are already present, press ENTER to overwrite or x to skip"
		read -sn1 input 
		[ "$input" = "" ] &&  sudo rm "$UDEV" || install=0
	fi
	
	if [ $install -eq 1 ]; then

		echo "[INFO] Downloading udev list..."
		_install "$UDEV" "$BASEURL/udev.txt"

		echo "[INFO] Fix permissions"
		output=$(sudo chmod 644 $UDEV 2>&1) && echo "[ OK ] Fixed." || { echo "[EROR] $output"; XCODE=1; }

		echo "[INFO] Fix ownership"
		output=$(sudo chown root: $UDEV 2>&1) && echo "[ OK ] Fixed." || { echo "[EROR] $output"; XCODE=1; }

		sudo service udev restart 2>/dev/null >&2
		sudo killall adb 2>/dev/null >&2
	else
		echo "[INFO] Skip.."
	fi
    fi
}

# get sudo

echo "[INFO] Nexus Tools 2.8"
echo "[INFO] Please enter sudo password for install."
sudo echo "[ OK ] Sudo access granted." || { echo "[ERROR] No sudo access!!"; exit 1; }

# check if already installed

if [ -f $ADB ]; then
    echo "[WARN] ADB is already present, press ENTER to overwrite or x to cancel."
    read -sn1 input
    [ "$input" = "" ] && sudo rm $ADB || exit 1
fi
if [ -f $FASTBOOT ]; then
    echo "[WARN] Fastboot is already present, press ENTER to overwrite or x to cancel."
    read -sn1 input
    [ "$input" = "" ] && sudo rm $FASTBOOT || exit 1
fi

# check if bin folder is already created
if [ ! -d /usr/local/bin/ ]; then
    sudo mkdir -p /usr/local/bin/
fi

# detect operating system and install

if [ "$OS" == "Darwin" ]; then # Mac OS X
    echo "[INFO] Downloading ADB for Mac OS X..."
    _install "$ADB" "$BASEURL/bin/mac-adb" 
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    _install "$FASTBOOT" "$BASEURL/bin/mac-fastboot"

    # download udev list
    _install_udev

    echo "[INFO] Making ADB and Fastboot executable..."
    output=$(sudo chmod +x $ADB 2>&1) && echo "[INFO] ADB now executable." || { echo "[EROR] $output"; XCODE=1; }
    output=$(sudo chmod +x $FASTBOOT 2>&1) && echo "[INFO] Fastboot now executable." || { echo "[EROR] $output"; XCODE=1; }
    
    echo "[INFO] Adding /usr/local/bin to PATH..."
    export PATH=$PATH:/usr/local/bin/

    [ $XCODE -eq 0 ] && { echo "[ OK ] Done!"; echo "[INFO] Type adb or fastboot to run."; } || { echo "[EROR] Install failed"; }
    echo " "
    exit $XCODE

elif [ "$OS" == "Linux" ]; then # Generic Linux

    if [ "$ARCH" == "i386" ] || [ "$ARCH" == "i486" ] || [ "$ARCH" == "i586" ] || [ "$ARCH" == "amd64" ] || [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i686" ]; then # Linux on Intel x86/x86_64 CPU
        echo "[INFO] Downloading ADB for Linux [Intel CPU]..."
        _install "$ADB" "$BASEURL/bin/linux-i386-adb"
        echo "[INFO] Downloading Fastboot for Linux [Intel CPU]..."
        _install "$FASTBOOT" "$BASEURL/bin/linux-i386-fastboot"

    elif [ "$ARCH" == "arm" ] || [ "$ARCH" == "armv6l" ] || [ "$ARCH" == "armv7l" ]; then # Linux on ARM CPU
        echo "[WARN] The ADB binaries for ARM are out of date, and do not work with Android 4.2.2 and higher"
        echo "[INFO] Downloading ADB for Linux [ARM CPU]..."
        _install "$ADB" "$BASEURL/bin/linux-arm-adb"
        echo "[INFO] Downloading Fastboot for Linux [ARM CPU]..."
        _install "$FASTBOOT" "$BASEURL/bin/linux-arm-fastboot"

    else
    	echo "[EROR] Your CPU architecture could not be detected."
    	echo "[EROR] Report bugs at: github.com/corbindavenport/nexus-tools/issues"
    	echo "[EROR] Report the following information in the bug report:"
    	echo "[EROR] OS: $OS"
    	echo "[EROR] ARCH: $ARCH"
    	echo " "
    	exit 1
    fi

    # download udev list
    _install_udev

    echo "[INFO] Making ADB and Fastboot executable..."
    output=$(sudo chmod +x $ADB 2>&1) && echo "[INFO] ADB OK." || { echo "[EROR] $output"; XCODE=1; }
    output=$(sudo chmod +x $FASTBOOT 2>&1) && echo "[INFO] Fastboot OK." || { echo "[EROR] $output"; XCODE=1; }
    
    echo "[INFO] Adding /usr/local/bin to $PATH..."
    export PATH=$PATH:/usr/local/bin/

    if [ $XCODE -eq 0 ]; then
	echo "[ OK ] Done, type adb or fastboot to run!"
    else
    	echo "[EROR] Install failed."
	echo "[EROR] Report bugs at: github.com/corbindavenport/nexus-tools/issues"
	echo "[EROR] Report the following information in the bug report:"
	echo "[EROR] OS: $OS"
	echo "[EROR] ARCH: $ARCH"
    fi
    echo " "
    exit $XCODE
else
    echo "[EROR] Your operating system or architecture could not be detected."
    echo "[EROR] Report bugs at: github.com/corbindavenport/nexus-tools/issues"
    echo "[EROR] Report the following information in the bug report:"
    echo "[EROR] OS: $OS"
    echo "[EROR] ARCH: $ARCH"
    echo " "
    exit 1
fi
