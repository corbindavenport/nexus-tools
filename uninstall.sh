#!/bin/bash

OS=$(uname)

if [ -d $HOME/.nexustools ]; then
	rm -rf "$HOME/.nexustools/"
	echo "Done!"
else
	echo "Nexus Tools installation not found."
fi