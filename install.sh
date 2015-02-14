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

# get sudo

echo "[INFO] Nexus Tools 2.4.1"
echo "[INFO] Please enter sudo password for install."
sudo echo "[ OK ] Sudo access granted."

# check if already installed

if [ -f $ADB ]; then
    read -p "[WARN] ADB is already present, press ENTER to overwrite or exit to cancel."
    sudo rm $ADB
fi
if [ -f $FASTBOOT ]; then
    read -p "[WARN] Fastboot is already present, press ENTER to overwrite or exit to cancel."
    sudo rm $FASTBOOT
fi

# detect operating system and install

if [ "$OS" == "Darwin" ]; then # Mac OS X
    echo "[INFO] Downloading ADB for Mac OS X..."
    sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/raw/master/bin/mac-adb" -LOk
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/raw/master/bin/mac-fastboot" -LOk
    echo "[INFO] Downloading udev list..."
    if [ -n "$UDEV" ]; then
        if [ ! -d /etc/udev/rules.d/ ]; then
            sudo mkdir -p /etc/udev/rules.d/
        fi
        sudo curl -s -o $UDEV "http://github.com/corbindavenport/nexus-tools/raw/master/udev.txt" -LOk
        sudo chmod 644 $UDEV
        sudo chown root. $UDEV 2>/dev/null
        sudo service udev restart 2>/dev/null
        sudo killall adb 2>/dev/null
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit 0
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # Generic Linux
    if [ "$ARCH" == "i386" ] || [ "$ARCH" == "i486" ] || [ "$ARCH" == "i586" ] || [ "$ARCH" == "amd64" ] || [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "i686" ]; then # Linux on Intel x86/x86_64 CPU
        echo "[INFO] Downloading ADB for Linux [Intel CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/raw/master/bin/linux-i386-adb" -LOk
        echo "[INFO] Downloading Fastboot for Linux [Intel CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/raw/master/bin/linux-i386-fastboot" -LOk
    elif [ "$ARCH" == "arm" ] || [ "$ARCH" == "armv6l" ]; then # Linux on ARM CPU
        echo "[WARN] The ADB binaries for ARM are out of date, and do not work on Android 4.2.2+"
        echo "[INFO] Downloading ADB for Linux [ARM CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/raw/master/bin/linux-arm-adb" -LOk
        echo "[INFO] Downloading Fastboot for Linux [ARM CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/raw/master/bin/linux-arm-fastboot" -LOk
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
        sudo curl -s -o $UDEV "http://github.com/corbindavenport/nexus-tools/raw/master/udev.txt" -LOk
        sudo chmod 644 $UDEV
        sudo chown root. $UDEV 2>/dev/null
        sudo service udev restart 2>/dev/null
        sudo killall adb 2>/dev/null
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit 0
else
    echo "[EROR] Your operating system or architecture could not be detected."
    echo "[EROR] Report bugs at: github.com/corbindavenport/nexus-tools/issues"
    echo "[EROR] Report the following information in the bug report:"
    echo "[EROR] OS: $OS"
    echo "[EROR] ARCH: $ARCH"
    echo " "
    exit 1
fi
