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

ADB="/usr/bin/adb"
FASTBOOT="/usr/bin/fastboot"

# get sudo

echo "[INFO] Nexus Tools 1.1"
echo "[INFO] Please enter sudo password for adb/fastboot removal"
sudo echo "[ OK ] Sudo access granted."

# remove files

if [ -f $ADB ];
then
   sudo rm $ADB
   echo "[ OK ] ADB removed."
else
   echo "[EROR] ADB not found in /usr/bin, skipping uninstall."
fi
if [ -f $FASTBOOT ];
then
   sudo rm $FASTBOOT
   echo "[ OK ] Fastboot removed."
else
   echo "[EROR] Fastboot not found in /usr/bin, skipping uninstall."
fi
echo "[ OK ] Done uninstalling!"
echo " "