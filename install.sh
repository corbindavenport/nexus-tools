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

# get sudo

echo "[INFO] Nexus Tools 2.0"
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

if [ -x "/usr/bin/crossystem" ]; then # Chrome OS
    sudo mount -o remount,rw / 2>/dev/null
    if [ "$?" -ne "0" ]; then
        if [ -x /usr/local/bin ]; then
            ADB=/usr/local/bin/adb
            FASTBOOT=/usr/local/bin/fastboot
            UDEV=
        fi
        /usr/bin/crossystem 'mainfw_type?developer'
    fi
    if [ "$?" -ne "0" ]; then
        
        echo "[INFO] It appears your Chromium/Chrome OS device is not in developer mode."
        echo "[INFO] Developer mode is needed to install ADB and Fastboot."
        echo "[INFO] Make sure your device is booted in developer mode."
        echo "[INFO] To set up developer tools, use this command: sudo dev_install"
        echo " "
        exit 1
    fi
    case "$(arch)" in
    i*86|amd64|x86_64)
        echo "[INFO] Downloading ADB for Chrome OS [Intel CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-i386-adb?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Chrome [Intel CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-i386-fastboot?raw=true" -LOk
        ;;
    arm|armv*)
        echo "[WARN] The ADB binaries for ARM are out of date, and do not work on Android 4.2.2+"
        echo "[INFO] Downloading ADB for Chrome OS [ARM CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-arm-adb?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Chrome OS [ARM CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-arm-fastboot?raw=true" -LOk
        ;;
    *)
    	echo "[EROR] Your CPU platform could not be detected. Now exiting."
    	echo " "
    	exit 1
    esac
    echo "[INFO] Downloading udev list..."
    if [ -n "$UDEV" ]; then
        sudo curl -s -o $UDEV "http://github.com/corbindavenport/nexus-tools/blob/master/udev.txt" -LOk
        sudo chmod 644   $UDEV
        sudo chown root. $UDEV
        sudo service udev restart
        sudo killall adb
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit 0
elif [ "$(uname)" == "Darwin" ]; then # Mac OS X
    echo "[INFO] Downloading ADB for Mac OS X..."
    sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/bin/mac-adb?raw=true" -LOk
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/bin/mac-fastboot?raw=true" -LOk
    echo "[INFO] Making ADB and Fastboot executable..."
    echo "[INFO] Downloading udev list..."
    sudo curl -s -o $UDEV "http://github.com/corbindavenport/nexus-tools/blob/master/udev.txt" -LOk
    sudo chmod 644 $UDEV
    sudo chown root. $UDEV
    sudo killall adb
    fi
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit 0
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # Generic Linux
    if [ "$(arch)" == "i386" ] || [ "$(arch)" == "i486" ] || [ "$(arch)" == "i586" ] || [ "$(arch)" == "amd64" ] || [ "$(arch)" == "x86_64" ] || [ "$(arch)" == "i686" ]; then # Linux on Intel x86/x86_64 CPU
        echo "[INFO] Downloading ADB for Linux [Intel CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-i386-adb?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Linux [Intel CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-i386-fastboot?raw=true" -LOk
    elif [ "$(arch)" == "arm" ] || [ "$(arch)" == "armv6l" ]; then # Linux on ARM CPU
        echo "[WARN] The ADB binaries for ARM are out of date, and do not work on Android 4.2.2+"
        echo "[INFO] Downloading ADB for Linux [ARM CPU]..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-arm-adb?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Linux [ARM CPU]..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/bin/linux-arm-fastboot?raw=true" -LOk
    else
    	echo "[EROR] Your CPU platform could not be detected. Now exiting."
    	echo " "
    	exit 0
    fi
    echo "[INFO] Downloading udev list..."
    if [ -n "$UDEV" ]; then
        sudo curl -s -o $UDEV "http://github.com/corbindavenport/nexus-tools/blob/master/udev.txt" -LOk
        sudo chmod 644   $UDEV
        sudo chown root. $UDEV
        sudo service udev restart
        sudo killall adb
    fi
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
    echo " "
    exit 0
else
    echo "[EROR] Your operating system could not be detected. Now exiting."
    exit 1
fi
