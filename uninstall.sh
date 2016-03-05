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

DIR="/usr/local/bin"
ADB="$DIR/adb"
FASTBOOT="$DIR/fastboot"
UDEV="/etc/udev/rules.d/51-android.rules"
OS=$(uname)
ARCH=$(uname -m)
XCODE=0
BASEURL="https://github.com/corbindavenport/nexus-tools/raw/master"

# get sudo

echo "[INFO] Nexus Tools 3.0"
echo "[INFO] Please enter sudo password for uninstall."
sudo echo "[ OK ] Sudo access granted." || { echo "[ERROR] No sudo access."; exit 1; }

# remove files

if [ -f $ADB ]; then
   sudo rm $ADB
   echo "[ OK ] ADB removed from $DIR/adb."
else
   if [ -f /usr/bin/adb ]; then
      sudo rm /usr/bin/adb
      echo "[ OK ] ADB removed from /usr/bin/adb."
   else
      echo "[INFO] ADB not found in /usr/local/bin or /usr/bin, skipping uninstall."
   fi
fi
if [ -f $FASTBOOT ]; then
   sudo rm $FASTBOOT
   echo "[ OK ] Fastboot removed from $DIR/fastboot."
else
   if [ -f /usr/bin/fastboot ]; then
      sudo rm /usr/bin/fastboot
      echo "[ OK ] ADB removed from /usr/bin/fastboot."
   else
      echo "[INFO] Fastboot not found in /usr/local/bin or /usr/bin, skipping uninstall."
   fi
fi
if [ -f $UDEV ]; then
   sudo rm $UDEV
   echo "[ OK ] Udev list removed."
else
   echo "[INFO] Udev list not found in /etc/udev/rules.d/, skipping uninstall."
fi
echo "[ OK ] Done uninstalling."
echo " "
