#!/bin/bash

OS=$(uname)

_install_brew_macos() {
	# Check if Brew is installed
	if ! [ -x "$(command -v brew)" ]; then
		echo "Setting up Brew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo "Brew is already installed."
	fi
	# Install Platform Tools
	brew install --force --cask android-platform-tools
	echo -e "\nInstallation complete! Run this command to update in the future: brew upgrade --cask"
}

echo "Nexus Tools is no longer supported. More details: https://github.com/corbindavenport/nexus-tools/README.md"

# Start Dart executable
if [ "$OS" = "Darwin" ]; then # macOS
	echo "Android SDK Platform Tools can be installed using the Brew package manager: https://brew.sh"
	echo "Do you want to install Brew (if not already installed)"
	echo "Press ENTER to proceed or X to cancel."
	read -sn1 udevinput
	[ "$udevinput" = "" ] && _install_brew_macos
else
	# TODO: Linux steps
fi