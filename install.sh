#!/bin/bash

# This script is just a wrapper to start the Dart executable from the GitHub releases page.

DIR="$HOME/.nexustools"
OS=$(uname)
ARCH=$(uname -m)
BASEURL="https://github.com/corbindavenport/nexus-tools"
DOWNLOAD=''
PARAMS="$@"

_run_executable() {
	cd $DIR
	curl -Lfs --progress-bar -o ./temp.zip $DOWNLOAD|| { echo "[EROR] Download failed."; exit; }
	unzip -q -o ./temp.zip
	rm ./temp.zip
	chmod +x ./nexustools*
	# Run Nexus Tools and pass parameters to the executable
	./nexustools* -i -w "$PARAMS"
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

# Make the new directory
mkdir -p $DIR

# Start Dart executable
if [ "$OS" = "Darwin" ]; then # macOS
	# Install Rosetta x86 emulation layer if needed
	ROSETTA_STATUS=$(/bin/launchctl list | /usr/bin/grep "com.apple.oahd-root-helper")
	ROSETTA_FOLDER="/Library/Apple/usr/share/rosetta"
	if [ "$ARCH" = "arm64" ]; then
		if [[ -e "${ROSETTA_FOLDER}" && "${ROSETTA_STATUS}" != "" ]]; then
			echo "[ OK ] Rosetta compatibility layer is already installed."
		else
			echo "[WARN] Apple Rosetta compatibility layer must be installed. Press ENTER to install or X to cancel."
			read -sn1 input
			[ "$input" = "" ] && /usr/sbin/softwareupdate --install-rosetta --agree-to-license || exit
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
