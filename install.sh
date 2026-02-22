#!/bin/bash

# This script only exists to avoid breaking guides and tutorials that include Nexus Tools.

OS=$(uname)

# Show discontinued message

echo -e "\nNexus Tools is now discontinued.\n"
if [ "$OS" = "Darwin" ] && [ -e "/opt/homebrew/bin/brew" ]; then # macOS with Brew installed
	echo -e "You already have Brew installed, you can install ADB and Fastboot with this command:\nbrew install --cask android-platform-tools"
elif [ "$OS" = "Darwin" ]; then # macOS without Brew
	echo -e "You can install ADB and Fastboot with the Brew package manager: https://brew.sh/\n\nThen run this command:\nbrew install --cask android-platform-tools"
elif [ "$OS" = "Linux" ]; then # Generic Linux 
	echo -e "ADB and Fastboot are probably in your package manager, with one of the below commands.\n\nUbuntu, Debian, Linux Mint, Pop OS, etc:\nsudo apt install android-sdk-platform-tools\n\nFedora:\ndnf install android-tools\n\nArch Linux:\npacman -S android-tools\n"
fi

# Ask user to remove existing installation

if [ -e "$HOME/.nexustools/adb" ]; then
	echo -e "\n==========\n\nADB and Fastboot have already been installed with Nexus Tools. You should delete them before installing with another method."
	read -p "Delete Nexus Tools installation? [Y/N] " prompt
	if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
	then
		rm -rf "$HOME/.nexustools/"
		echo "Done!"
	else
		exit 0
	fi
fi

echo ""