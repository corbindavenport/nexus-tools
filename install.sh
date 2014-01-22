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

# get sudo

echo "[INFO] Nexus Tools Installer 1.0"
echo "[INFO] Please enter sudo password for adb/fastboot install"
sudo echo "[ OK ] Sudo access granted."

# check operating system

if [ "$(uname)" == "Darwin" ]; then # Mac OS X
	cd /usr/bin/
	echo "[INFO] Downloading ADB for Mac OS X..."
    sudo curl -s -o adb "http://github.com/corbindavenport/nexus-tools/blob/master/macosx/adb?raw=true" -LOk
    echo "[ OK ] ADB finished downloading."
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    sudo curl -s -o fastboot "http://github.com/corbindavenport/nexus-tools/blob/master/macosx/fastboot?raw=true" -LOk
    echo "[ OK ] Fastboot finished downloading."
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x ./adb
    sudo chmod +x ./fastboot
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then # Linux
    cd /usr/bin/
	echo "[INFO] Downloading ADB for Linux..."
    sudo curl -s -o adb "http://github.com/corbindavenport/nexus-tools/blob/master/linux/adb?raw=true" -LOk
    echo "[ OK ] ADB finished downloading."
    echo "[INFO] Downloading Fastboot for Linux..."
    sudo curl -s -o fastboot "http://github.com/corbindavenport/nexus-tools/blob/master/linux/fastboot?raw=true" -LOk
    echo "[ OK ] Fastboot finished downloading."
    echo "[INFO] Making ADB and Fastboot executable..."
    sudo chmod +x ./adb
    sudo chmod +x ./fastboot
    echo "[ OK ] Done!"
    echo "[INFO] Type adb or fastboot to run."
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then # Cygwin on Windows
    echo "[WARN] Nexus Tools Installer currently not compatible with Cygwin. Now exiting."
fi
