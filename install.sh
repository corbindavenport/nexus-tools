#!/bin/bash

# This script is a wrapper to start the Dart executable from the GitHub releases page.

OS=$(uname)
ARCH=$(uname -m)
BASEURL="https://github.com/corbindavenport/nexus-tools"

# Check that required applications are installed
if ! [ -x "$(command -v curl)" ]; then
  echo "[EROR] The 'curl' command is not installed. Please install it and run Nexus Tools again."
  exit
fi

# Start Dart executable
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
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-macos-x64"
	curl -Lfk --progress-bar -o ./exec $DOWNLOAD|| { echo "[EROR] Download failed."; exit; }
	chmod +x ./exec
	./exec
	rm ./exec
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]; then # Generic Linux 
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-linux-x64"
	curl -Lfk --progress-bar -o ./exec $DOWNLOAD|| { echo "[EROR] Download failed."; exit; }
	chmod +x ./exec
	./exec
	rm ./exec
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "amd64" ]; then # Generic Linux 
	DOWNLOAD="$BASEURL/releases/latest/download/nexustools-linux-x64"
	curl -Lfk --progress-bar -o ./exec $DOWNLOAD|| { echo "[EROR] Download failed."; exit; }
	chmod +x ./exec
	./exec
	rm ./exec
else
	echo "[EROR] Your OS or CPU architecture doesn't seem to be supported."
	echo "[EROR] Detected OS: $OS"
	echo "[EROR] Detected arch: $ARCH"
	exit
fi
