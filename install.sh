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

ADB="/usr/bin/adb"
FASTBOOT="/usr/bin/fastboot"
UDEV="/etc/udev/rules.d/51-android.rules"
OS=$(uname)
ARCH=$(uname -m)

XCODE=0

BASEURL="http://github.com/corbindavenport/nexus-tools/raw/master"


_install() {
	sudo curl -Lfks -o "$1" "$2" && echo "[INFO] Success." || { echo "[EROR] Download failed."; XCODE=1; }
}

# get sudo

echo "[INFO] Nexus Tools 2.4.1"
echo "[INFO] Please enter sudo password for install."
sudo echo "[ OK ] Sudo access granted." || { echo "[ERROR] No sudo access!!"; exit 1; }

# check if already installed

if [ -f $ADB ]; then
    read -n1 -p "[WARN] ADB is already present, press ENTER to overwrite or exit to cancel." input
    [ "$input" = "" ] && sudo rm $ADB || exit 1
fi
if [ -f $FASTBOOT ]; then
    read -n1 -p "[WARN] Fastboot is already present, press ENTER to overwrite or exit to cancel." input
    [ "$input" = "" ] && sudo rm $FASTBOOT || exit 1
fi

# detect operating system and install

if [ "$OS" == "Darwin" ]; then # Mac OS X
    echo "[INFO] Downloading ADB for Mac OS X..."
    _install "$ADB" "$BASEURL/bin/mac-adb" 
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    _install "$FASTBOOT" "$BASEURL/bin/mac-fastboot"
    echo "[INFO] Downloading udev list..."
    if [ -n "$UDEV" ]; then
        if [ ! -d /etc/udev/rules.d/ ]; then
            sudo mkdir -p /etc/udev/rules.d/
        fi
        _install "$UDEV" "$BASEURL/udev.txt"
        sudo chmod 644 $UDEV
        sudo chown root: $UDEV 2>/dev/null
        sudo service udev restart 2>/dev/null
        sudo killall adb 2>/dev/null
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit $XCODE 
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # Generic Linux
    if [ "$ARCH" == "i386" ] || [ "$ARCH" == "i486" ] || [ "$ARCH" == "i586" ] || [ "$ARCH" == "amd64" ] || [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i686" ]; then # Linux on Intel x86/x86_64 CPU
        echo "[INFO] Downloading ADB for Linux [Intel CPU]..."
        _install "$ADB" "$BASEURL/bin/linux-i386-adb"
        echo "[INFO] Downloading Fastboot for Linux [Intel CPU]..."
        _install "$FASTBOOT" "$BASEURL/bin/linux-i386-fastboot"
    elif [ "$ARCH" == "arm" ] || [ "$ARCH" == "armv6l" ]; then # Linux on ARM CPU
        echo "[WARN] The ADB binaries for ARM are out of date, and do not work on Android 4.2.2+"
        echo "[INFO] Downloading ADB for Linux [ARM CPU]..."
        _install "$ADB" "$BASEURL/bin/linux-arm-adb"
        echo "[INFO] Downloading Fastboot for Linux [ARM CPU]..."
        _install "$FASTBOOT" "$BASEURL/bin/linux-arm-fastboot"
    else
    	echo "[EROR] Your CPU platform could not be detected."
    	echo " "
    	exit 1
    fi
    echo "[INFO] Downloading udev list..."
    if [ -n "$UDEV" ]; then
        if [ ! -d /etc/udev/rules.d/ ]; then
            sudo mkdir -p /etc/udev/rules.d/
        fi
        _install "$UDEV" "$BASEURL/udev.txt"
	echo "[INFO] Fix permissions"
        output=$(sudo chmod 644 $UDEV 2>&1) && echo "[INFO] OK" || { echo "[EROR] $output"; XCODE=1; }
	echo "[INFO] Fix ownership"
        output=$(sudo chown root: $UDEV 2>&1) && echo "[INFO] OK" || { echo "[EROR] $output"; XCODE=1; }

        sudo service udev restart 2>/dev/null >&2
        sudo killall adb 2>/dev/null >&2
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    output=$(sudo chmod +x $ADB 2>&1) && echo "[INFO] OK" || { echo "[EROR] $output"; XCODE=1; }
    output=$(sudo chmod +x $FASTBOOT 2>&1) && echo "[INFO] OK" || { echo "[EROR] $output"; XCODE=1; }
    [ $XCODE -eq 0 ] && { echo "[ OK ] Done!"; echo "[INFO] Type adb or fastboot to run."; } || { echo "[EROR] Install failed"; }
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
