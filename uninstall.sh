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

OS=$(uname)
ARCH=$(uname -m)

echo "[INFO] Nexus Tools 4.0"

# Nexus Tools 3.2+ (August 2016-) installs binaries in ~/.nexustools
if [ -d $DIR ]; then
	echo "[WARN] Nexus Tools folder found in $HOME/.nexustools. Press ENTER to delete or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && rm -rf $HOME/.nexustools
fi

# Nexus Tools 2.8-3.1 (October 2015-August 2016) installed binaries in /user/local/bin
if [ -f /usr/local/bin/adb ]; then
	echo "[WARN] ADB found in /usr/local/bin. It may have been installed there by an old version of Nexus Tools."
    echo "[WARN] Sudo access is required to remove. Press ENTER to delete or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && sudo rm /usr/local/bin/adb
fi
if [ -f /usr/local/bin/fastboot ]; then
	echo "[WARN] Fasboot found in /usr/local/bin. It may have been installed there by an old version of Nexus Tools."
    echo "[WARN] PSudo access is required to remove. ress ENTER to delete or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && sudo rm /usr/local/bin/fastboot
fi

# Nexus Tools 1.0-2.7.1 (December 2013-October 2015) installed binaries in /usr/bin
if [ -f /usr/bin/adb ]; then
	echo "[WARN] ADB found in /usr/bin. It may have been installed there by an old version of Nexus Tools."
    echo "[WARN] Sudo access is required to remove. Press ENTER to delete or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && sudo rm /usr/bin/adb
fi
if [ -f /usr/bin/fastboot ]; then
	echo "[WARN] Fasboot found in /usr/bin. It may have been installed there by an old version of Nexus Tools."
    echo "[WARN] Sudo access is required to remove. Press ENTER to delete or X to cancel."
	read -sn1 input
	[ "$input" = "" ] && sudo rm /usr/bin/fastboot
fi

echo "[ OK ] Uninstall complete."
echo ""
