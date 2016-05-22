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

ADB="$HOME/.nexustools/adb"
FASTBOOT="$HOME/.nexustools/fastboot"
UDEV="/etc/udev/rules.d/51-android.rules"
OS=$(uname)
ARCH=$(uname -m)
XCODE=0
BASEURL="https://github.com/corbindavenport/nexus-tools/raw/master"

_install() {
	sudo curl -Lfks -o "$1" "$2" && echo "[ OK ] Download succeeded."|| { echo "[EROR] Download failed."; XCODE=1; }
}

# If Nexus Tools is detects the ADB and/or Fastboot binaries, and it cannot detect it as part of an Linux package it can remove, it removes the binaries themselves. This is the default for Mac OS X.
_dirty_remove() {
	if [ -f "$HOME/.nexustools/nexus-tools.txt" ]; then
		echo "[ OK ] Log file detected."
	fi
	if [ -f $ADB ]; then
			echo "[WARN] ADB is already present, press ENTER to overwrite or X to cancel."
			read -sn1 input
			[ "$input" = "" ] && sudo rm $ADB || exit 1
	fi
	if [ -f $FASTBOOT ]; then
			echo "[WARN] Fastboot is already present, press ENTER to overwrite or X to cancel."
			read -sn1 input
			[ "$input" = "" ] && sudo rm $FASTBOOT || exit 1
	fi
}

# Nexus Tools can check if a package for ADB or Fastboot is installed, and uninstall the package if needed.
_smart_remove() {
	if [ -x "$(command -v dpkg)" ]; then # Linux systems with dpkg
		PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
		if [ "" == "$PKG_OK" ]; then # Check if relevant package is installed
				echo "[ OK] The package '$1' is not installed, install can continue."
				_dirty_remove
		else
			echo "[WARN] An outdated version of ADB or Fastboot is already installed, as part of the '$1' system package. Press ENTER to remove it or X to cancel."
			read -sn1 input
			[ "$input" = "" ] && sudo apt-get --assume-yes remove $1 && echo "[ OK ] The '$1' package was removed." || exit 1
		fi
	else
		echo "[INFO] Linux is detected but dpkg is either not working or not installing, now attempting dirty removal."
		_dirty_remove
	fi
}

_install_udev() {
    if [ -n "$UDEV" ] && [ "$OS" == "Linux" ]; then
        if [ ! -d /etc/udev/rules.d/ ]; then
            sudo mkdir -p /etc/udev/rules.d/
        fi

	local install=1

	if [ -f "$UDEV" ]; then
		sudo rm "$UDEV"
		echo "[ OK ] Udev rules are being overwritten."
	fi

	if [ $install -eq 1 ]; then

		echo "[INFO] Downloading udev list..."
		_install "$UDEV" "$BASEURL/udev.txt"

		output=$(sudo chmod 644 $UDEV 2>&1) && echo "[ OK ] UDEV permissions fixed." || { echo "[EROR] $output"; XCODE=1; }

		output=$(sudo chown root: $UDEV 2>&1) && echo "[ OK ] UDEV ownership fixed." || { echo "[EROR] $output"; XCODE=1; }

		sudo service udev restart 2>/dev/null >&2
		sudo killall adb 2>/dev/null >&2
	else
		echo "[INFO] Skipping UDEV..."
	fi
    fi
}

# Get sudo
echo "[INFO] Nexus Tools 3.1"
if [ "$OS" == "Linux" ]; then
	GCC=$(gcc --version)
	DISTRO="Ubuntu"
	if [ -z "${GCC##*$DISTRO*}" ]; then
			:
	else
		echo "[WARN] Nexus Tools is only tested to work on Ubuntu Linux, but it should work on other distributions."
	fi
fi
echo "[INFO] Please enter sudo password for install."
sudo echo "[ OK ] Sudo access granted." || { echo "[ERROR] No sudo access."; exit 1; }

# Check if ADB or Fastboot is already on this computer
if [ "$OS" == "Linux" ]; then
	GCC=$(gcc --version)
	# If someone wants to add support, this should work with any distro using dpkg for package management. Just change the paramteter to whatever package installs ADB/Fastboot binaries.
	if [ -z "${GCC##*Ubuntu*}" ]; then
		_smart_remove "android-tools-adb"
		_smart_remove "android-tools-fastboot"
	elif [ -z "${GCC##*Debian*}" ]; then
		_smart_remove "android-tools-adb"
		_smart_remove "android-tools-fastboot"
	else
		echo "[WARN] Nexus Tools cannot detect if you have an ADB/Fastboot package already installed on your system."
		echo "[WARN] Nexus Tools will still check for ADB/Fastboot binaries, but if they are installed as a package it may overwrite the original files."
		_dirty_remove
	fi
else
	_dirty_remove
fi

# Check if bin folder is already created
mkdir -p $HOME/.nexustools

# Detect operating system and install
if [ "$OS" == "Darwin" ]; then # Mac OS X
    echo "[INFO] Downloading ADB for Mac OS X..."
    _install "$ADB" "$BASEURL/bin/mac-adb"
    echo "[INFO] Downloading Fastboot for Mac OS X..."
    _install "$FASTBOOT" "$BASEURL/bin/mac-fastboot"

    # Skip udev install because Mac OS X doesn't use it

    echo "[INFO] Making ADB and Fastboot executable..."
    output=$(sudo chmod +x $ADB 2>&1) && echo "[INFO] ADB now executable." || { echo "[EROR] $output"; XCODE=1; }
    output=$(sudo chmod +x $FASTBOOT 2>&1) && echo "[INFO] Fastboot now executable." || { echo "[EROR] $output"; XCODE=1; }

    echo "[INFO] Adding $HOME/.nexustools to \$PATH..."
    PATH=~/.nexustools:$PATH echo 'export PATH=$PATH:~/.nexustools' >> ~/.bash_profile

    [ $XCODE -eq 0 ] && { echo "[ OK ] Done!"; echo "[INFO] Type adb or fastboot to run, you may need to open a new Terminal window for it to work."; echo "[INFO] If you found Nexus Tools helpful, please consider donating to support development: bit.ly/donatenexustools"; } || { echo "[EROR] Install failed"; }
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

    # Download udev list
    _install_udev

    output=$(sudo chmod +x $ADB 2>&1) && echo "[ OK ] Marked ADB as executable." || { echo "[EROR] $output"; XCODE=1; }
    output=$(sudo chmod +x $FASTBOOT 2>&1) && echo "[ OK ] Marked ADB as executable." || { echo "[EROR] $output"; XCODE=1; }

    echo "[INFO] Adding $HOME/.nexustools to \$PATH..."
    PATH="$PATH:$HOME/.nexustools"

    if [ $XCODE -eq 0 ]; then
	echo "[ OK ] Type adb or fastboot to run, you may need to open a new Terminal window for it to work."
	echo "[INFO] If you found Nexus Tools helpful, please consider donating to support development: bit.ly/donatenexustools"
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
