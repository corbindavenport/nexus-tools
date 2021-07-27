#!/bin/bash

# This script only exists to maintain compatibility with guides and tutorials that mention Nexus Tools. Nexus Tools can be uninstalled by running nexustools -r in the Terminal, or by deleting ~/.nexustools manually.

OS=$(uname)
ARCH=$(uname -m)

# Nexus Tools 3.2+ (August 2016-Now) installs binaries in ~/.nexustools
if [ -d $HOME/.nexustools ]; then
	echo "[WARN] Nexus Tools folder found in $HOME/.nexustools. Press ENTER to delete or X to skip."
	read -sn1 input
	[ "$input" = "" ] && rm -rf $HOME/.nexustools
else
	echo "[ OK ] No installation found."
fi