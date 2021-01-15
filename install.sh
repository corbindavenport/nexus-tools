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

DIR="$HOME/.nexustools"
UDEV="/etc/udev/rules.d/51-android.rules"
UDEVURL="https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules"
INIURL="https://raw.githubusercontent.com/apkudo/adbusbini/master/adb_usb.ini"
OS=$(uname)
ARCH=$(uname -m)
BASEURL="https://github.com/corbindavenport/nexus-tools/raw/master"
XCODE=0
ANALYTICS=$1

# Function for copying udex.txt to proper location
_install_udev() {
	# Install UDEV file
	if [ ! -d /etc/udev/rules.d/ ]; then
		sudo mkdir -p /etc/udev/rules.d/
	fi
	if [ -f "$UDEV" ]; then
		sudo rm "$UDEV"
	fi
	echo "[ .. ] Downloading UDEV file..."
	sudo curl -Lfk --progress-bar -o "$UDEV" "$UDEVURL"
	output=$(sudo chmod 644 $UDEV 2>&1) && echo "[ OK ] UDEV permissions fixed." || { echo "[EROR] $output"; XCODE=1; }
	output=$(sudo chown root: $UDEV 2>&1) && echo "[ OK ] UDEV ownership fixed." || { echo "[EROR] $output"; XCODE=1; }
	# Restart services
	sudo udevadm control --reload-rules 2>/dev/null >&2
	sudo service udev restart 2>/dev/null >&2
	sudo killall adb 2>/dev/null >&2
}

# Function for installing USB Vendor ID list (required for some devices to connect)
# More info: https://apkudo.com/one-true-adb_usb-ini-to-rule-them-all/
_install_ini() {
	if [ ! -d $HOME/.android/ ]; then
		mkdir -p $HOME/.android/
	fi
	if [ -f "$HOME/.android/adb_usb.ini" ]; then
		rm "$HOME/.android/adb_usb.ini"
	fi
	echo "[ .. ] Downloading ADB Vendor ID file..."
	curl -Lfk --progress-bar -o "$HOME/.android/adb_usb.ini" "$INIURL"
}

# Function for adding Nexus Tools directory to $PATH
_add_path() {
	if [[ ":$PATH:" == *":$DIR:"* ]]; then
		# Nexus Tools directory already in $PATH
		echo "[ OK ] $DIR/ is already in PATH."
	else
		# Nexus Tools directory needs to be added to $PATH
		if [[ $SHELL == *"bash"* ]]; then
			echo 'export PATH=$PATH:'$DIR >> $HOME/.bashrc
			source "$HOME/.bashrc"
			echo "[ OK ] Bash shell detected, added $DIR/ to $HOME/.bashrc."
		elif [[ $SHELL == *"zsh"* ]]; then
			echo 'export PATH=$PATH:'$DIR >> $HOME/.zshrc
			source "$HOME/.zshrc"
			echo "[ OK ] Z Shell detected, added $DIR/ to $HOME/.zshrc."
		else
			echo "[WARN] Shell could not be detected, you will need to manually add $DIR to your PATH."
		fi
	fi
}

# Function for reporting bugs
_report_bug() {
	echo "[EROR] Your CPU architecture or operating system could not be detected."
	echo "[EROR] Report bugs at: github.com/corbindavenport/nexus-tools/issues"
	echo "[EROR] Please include the following information in the bug report:"
	echo "[EROR] OS: $OS"
	echo "[EROR] ARCH: $ARCH"
	echo " "
}

# Function for Google Analytics
_analytics() {
	if [ "$ANALYTICS" != "no-analytics" ]; then
		# Generate random user ID string
		if [ -x "$(command -v uuidgen)" ]; then
			UUID=$(uuidgen)
		elif [ -f "/proc/sys/kernel/random/uuid" ]; then
			UUID=$(cat /proc/sys/kernel/random/uuid)
		else
			UUID="00000000-0000-0000-0000-000000000000"
		fi
		# Get exact OS
		if [ -d "/mnt/c/Windows" ]; then
			REALOS="Windows"
		elif [ -d "/usr/share/themes/CrosAdapta" ]; then
			REALOS="ChromeOS"
		else
			REALOS="$OS"
		fi
		# Make curl request
		curl -s -o /dev/null "https://www.google-analytics.com/collect?v=1&t=pageview&tid=UA-74707662-1&cid=$UUID&dp=$REALOS%2F$ARCH"
	else
		echo "[ OK ] Google Analytics are disabled."
	fi
}

# Start the script
echo "[INFO] Nexus Tools 4.4"

# Check that required applications are installed
if ! [ -x "$(command -v curl)" ]; then
  echo "[EROR] The 'curl' command is not installed. Please install it and run Nexus Tools again."
  exit 1
fi
if ! [ -x "$(command -v unzip)" ]; then
  echo "[EROR] The 'unzip' command is not installed. Please install it and run Nexus Tools again."
  exit 1
fi

# Start Analytics
_analytics

# Delete existing Nexus Tools installation if it exists
if [ -d $DIR ]; then
	echo "[WARN] Platform tools already installed in $DIR. Press ENTER to overwrite or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && rm -rf $DIR || exit 1
fi

# Make the new directory
mkdir -p $DIR

# Check if platform tools are already installed
if [ -x "$(command -v adb)" ]; then
	echo "[EROR] ADB is already installed and Nexus Tools cannot remove it automatically. Please manually uninstall ADB and try again."
	exit 1
fi
if [ -x "$(command -v fastboot)" ]; then
	echo "[EROR] Fastboot is already installed and Nexus Tools cannot remove it automatically. Please manually uninstall Fastboot and try again."
	exit 1
fi

# Block installation on non-x86 platforms
if [ "$ARCH" = "i386" ] || [ "$ARCH" = "i486" ] || [ "$ARCH" = "i586" ] || [ "$ARCH" = "amd64" ] || [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "i686" ]; then
	echo "[ OK ] Your hardware platform is supported, yay!"
elif [ "$ARCH" = "arm64" ] && [ "$OS" = "Darwin" ]; then
	echo "[WARN] Google doesn't provide native Apple Silicon binaries yet, x86_64 binaries will be installed."
else
	echo "[EROR] Your hardware platform is detected as $ARCH, but Google only provides Platform Tools for x86-based platforms."
	echo "[EROR] Installation cannot continue."
	echo " "
	exit 1
fi

# Detect operating system and install
if [ -d "/mnt/c/Windows" ]; then # Windows 10 Bash
	echo "[WARN] Bash on Windows 10 doesn't support USB devices, you'll only be able to use ADB over Wi-Fi."
	ZIP="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
	# Download the ZIP file
	echo "[ .. ] Downloading platform tools for x86 Linux..."
	curl -Lfk --progress-bar -o "$DIR/temp.zip" "$ZIP"|| { echo "[EROR] Download failed."; XCODE=1; }
	# Unzip it
	unzip -q -o "$DIR/temp.zip" -d "$DIR"
	# Move all files from the zip to $DIR
	mv -f -v $DIR/platform-tools/* $DIR > /dev/null
	# Delete the zip file and original folder
	rm "$DIR/temp.zip"
	rmdir "$DIR/platform-tools"
	echo "[ OK ] Platform Tools now installed in $DIR."
	# Add Nexus Tools directory to $PATH
	_add_path
	# Mark binaries in directory as executable
	chmod -f +x $DIR/*
	# Download Device ID list
	_install_ini
	# Download udev list
	echo "[INFO] Nexus Tools can install UDEV rules to fix potential USB issues."
	echo "[INFO] Sudo access is required. Press ENTER to proceed or X to skip."
	read -sn1 udevinput
	[ "$udevinput" = "" ] && _install_udev
elif [ "$OS" = "Darwin" ]; then # macOS
	ZIP="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
	# Download the ZIP file
	echo "[ .. ] Downloading platform tools for macOS..."
	curl -Lfk --progress-bar -o "$DIR/temp.zip" "$ZIP"|| { echo "[EROR] Download failed."; XCODE=1; }
	# Unzip it
	unzip -q -o "$DIR/temp.zip" -d "$DIR"
	# Move all files from the zip to $DIR
	mv -f -v $DIR/platform-tools/* $DIR > /dev/null
	# Delete the zip file and original folder
	rm "$DIR/temp.zip"
	rmdir "$DIR/platform-tools"
	echo "[ OK ] Platform Tools now installed in $DIR."
	# Mark binaries in directory as executable
	chmod -f +x $DIR/*
	# Download Device ID list
	_install_ini
	# Add Nexus Tools directory to $PATH
	_add_path
elif [ "$OS" = "Linux" ]; then # Generic Linux
	if [ -d "/usr/share/themes/CrosAdapta" ]; then
		echo "[WARN] Chrome OS 75 or higher is required for USB support."
	fi
	ZIP="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
	# Download the ZIP file
	echo "[ .. ] Downloading platform tools for x86 Linux..."
	curl -Lfk --progress-bar -o "$DIR/temp.zip" "$ZIP"|| { echo "[EROR] Download failed."; XCODE=1; }
	# Unzip it
	unzip -q -o "$DIR/temp.zip" -d "$DIR"
	# Move all files from the zip to $DIR
	mv -f -v $DIR/platform-tools/* $DIR > /dev/null
	# Delete the zip file and original folder
	rm "$DIR/temp.zip"
	rmdir "$DIR/platform-tools"
	echo "[ OK ] Platform Tools now installed in $DIR."
	# Add Nexus Tools directory to $PATH
	_add_path
	# Mark binaries in directory as executable
	chmod -f +x $DIR/*
	# Download Device ID list
	_install_ini
	# Download udev list
	echo "[INFO] Nexus Tools can install UDEV rules to fix potential USB issues."
	echo "[INFO] Sudo access is required. Press ENTER to proceed or X to skip."
	read -sn1 udevinput
	[ "$udevinput" = "" ] && _install_udev
else
	_report_bug
	exit 1
fi

# All done
if [ $XCODE -eq 0 ]; then
	echo "[INFO] Installation complete! Open a new Terminal window to apply changes."
	echo "[INFO] Donate to support development: bit.ly/donatenexustools or patreon.com/corbindavenport"
else
	_report_bug
fi
echo " "
exit $XCODE
