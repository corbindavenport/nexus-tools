nexus-tools
===========

Nexus Tools is an installer for the Android debug/development command-line tools ADB (Android Device Bridge) and Fastboot for Mac OS X, Linux, and Google Chrome/Chromium OS. The script does not need to be downloaded, simply copy and paste this command into the terminal and run it to install Nexus Tools:
```
bash <(curl https://raw.github.com/corbindavenport/nexus-tools/master/install.sh)
```
and this command to un-install Nexus Tools:
```
bash <(curl https://raw.github.com/corbindavenport/nexus-tools/master/uninstall.sh)
```
These commands will download the selected script and run it. The script will download the files it needs during runtime, so it requires an internet connection. The script works on both Mac OS X and Linux (as long as the curl package is installed).

Support for Google Chrome OS is experimental at this time, as I was only able to test it on a build of Chromium for x86 PCs. I don't have an actual Chromebook to test it on, but Nexus Tools should work correctly on both x86 and ARM Chromebooks.

Nexus Tools requires sudo privileges to install/uninstall the adb and fastboot tools to /usr/bin, so they can be run without typing the full directory.

---------------------------------------

__XDA Thread:__ [http://forum.xda-developers.com/showthread.php?t=2564453](http://forum.xda-developers.com/showthread.php?t=2564453)

---------------------------------------

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
