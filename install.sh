#!/bin/bash

# This script is a wrapper to start the Dart executable from the GitHub releases page.

OS=$(uname)
ARCH=$(uname -m)
BASEURL="https://github.com/corbindavenport/nexus-tools"
DOWNLOAD=''

_run_executable() {
	curl -Lfs --progress-bar -o ./temp.zip $DOWNLOAD|| { echo "[EROR] Download failed."; exit; }
	unzip -q -o ./temp.zip
	rm ./temp.zip
	chmod +x ./nexustools*
	if [ "$OS" = "Darwin" ]; then
		echo "[WARN] Nexus Tools is not a signed executable, sudo permission is required to add Nexus Tools as a security exception."
		echo "[WARN] More info: https://github.com/corbindavenport/nexus-tools/wiki/Nexus-Tools-on-macOS"
		sudo xattr -cr ./nexustools*
	fi
	./nexustools* $1
	rm ./nexustools*
}

# Check that required applications are installed
if ! [ -x "$(command -v curl)" ]; then
  echo "[EROR] The 'curl' command is not installed. Please install it and run Nexus Tools again."
  exit
fi
if ! [ -x "$(command -v unzip)" ]; then
  echo "[EROR] The 'unzip' command is not installed. Please install it and run Nexus Tools again."
  exit
fi

# Start Dart executable
cd $HOME
if [ "$OS" = "Darwin" ]; then # macOS
	# Install Rosetta x86 emulation layer if needed
	if [ "$ARCH" = "arm64" ]; then
		if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]]; then
			echo "[WARN] Apple Rosetta compatibility layer must be installed. Press ENTER to install or X to cancel."
			read -sn1 input
			[ "$input" = "" ] && /usr/sbin/softwareupdate --install-rosetta --agree-to-license || exit
		else
			echo "[ OK ] Rosetta compatibility layer is already installed."
		fi
	fi
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-macos-x64.zip"
	_run_executable
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]; then # Generic Linux 
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-linux-x64.zip"
	_run_executable
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "amd64" ]; then # Generic Linux 
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-linux-x64.zip"
	_run_executable
else
	echo "[EROR] Your OS or CPU architecture doesn't seem to be supported."
	echo "[EROR] Detected OS: $OS"
	echo "[EROR] Detected arch: $ARCH"
	exit
fi
