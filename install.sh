#!/bin/bash

# get sudo

echo "[INFO] Nexus Tools Installer 1.0"
echo "[INFO] Please enter sudo password for adb/fastboot install"
sudo echo "[ OK ] Sudo access granted."

# check operating system

if [ "$(uname)" == "Darwin" ]; then
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
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
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
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "[WARN] Nexus Tools Installer currently not compatible with Cygwin. Now exiting."
fi