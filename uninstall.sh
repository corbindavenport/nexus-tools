#!/bin/bash

OS=$(uname)

if [ -d $HOME/.nexustools ]; then
	adb kill-server
	rm -rf "$HOME/.nexustools/"
	echo "Done!"
else
	echo "Nexus Tools installation not found."
fi