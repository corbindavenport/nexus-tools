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

# get sudo

echo "[INFO] Nexus Tools 1.1"
echo "[INFO] Please enter sudo password for adb/fastboot install"
sudo echo "[ OK ] Sudo access granted."

# check if already installed

if [ -f $ADB ]; then
    read -p "[INFO] ADB is already present, press ENTER to overwrite or exit to cancel."
    sudo rm $ADB
fi
if [ -f $FASTBOOT ]; then
    read -p "[INFO] Fastboot is already present, press ENTER to overwrite or exit to cancel."
    sudo rm $FASTBOOT
fi

# detect operating system and install

if [ -f "/usr/bin/old_bins/chromeos-tpm-recovery" ]; then # Chrome OS
    sudo mount -o remount,rw /
    if [ "$(arch)" == "arm" ]; then # Chrome OS on ARM CPU
        echo "[INFO] Downloading ADB for Chrome OS (ARM CPU)..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/chromeos/adb-arm?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Chrome OS (ARM CPU)..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/chromeos/fastboot-arm?raw=true" -LOk
    else  # Chrome OS on Intel CPU
        echo "[INFO] Downloading ADB for Chrome OS (Intel CPU)..."
        sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/chromeos/adb-x86?raw=true" -LOk
        echo "[INFO] Downloading Fastboot for Chrome OS (Intel CPU)..."
        sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/chromeos/fastboot-x86?raw=true" -LOk
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
    sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/macosx/adb?raw=true" -LOk
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/macosx/fastboot?raw=true" -LOk
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # Linux
    echo "[INFO] Downloading ADB for Linux..."
    sudo curl -s -o $ADB "http://github.com/corbindavenport/nexus-tools/blob/master/linux/adb?raw=true" -LOk
    echo "[INFO] Downloading Fastboot for Linux..."
    sudo curl -s -o $FASTBOOT "http://github.com/corbindavenport/nexus-tools/blob/master/linux/fastboot?raw=true" -LOk
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x $ADB
    sudo chmod +x $FASTBOOT
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then # Cygwin on Windows
    echo "[WARN] Nexus Tools Installer currently not compatible with Cygwin. Now exiting."
fi
echo " "
