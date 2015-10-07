![alt text](http://i.imgur.com/shjM51Q.png "Nexus Tools")

---------------------------------------

Nexus Tools is an installer for the Android debug/development command-line tools ADB (Android Device Bridge) and Fastboot for Mac OS X and Linux. The script does not need to be downloaded, simply copy and paste this command into the terminal and run it to install ADB/Fastboot:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```
and this command to un-install ADB/Fastboot:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/uninstall.sh)
```
These commands will download the selected script and run it. The script will download the files it needs during runtime, so it requires an internet connection. The script works on both Mac OS X and Linux (as long as the curl package is installed).

Nexus Tools requires sudo privileges to install/uninstall the adb and fastboot tools to /usr/local/bin, so they can be run without typing the full directory.

---------------------------------------

__Alternate Install__

If you have errors with the above install command, you can try this one:

```
cd ~ && curl -s -o ./install.sh "http://github.com/corbindavenport/nexus-tools/raw/master/install.sh" -LOk && chmod +x ./install.sh && ./install.sh && rm ./install.sh
```

and to un-install:

```
cd ~ && curl -s -o ./uninstall.sh "http://github.com/corbindavenport/nexus-tools/raw/master/uninstall.sh" -LOk && chmod +x ./uninstall.sh && ./uninstall.sh && rm ./uninstall.sh
```
---------------------------------------

__XDA Thread:__ [http://forum.xda-developers.com/showthread.php?t=2564453](http://forum.xda-developers.com/showthread.php?t=2564453)

__XDA Article:__ [http://www.xda-developers.com/android/set-up-adb-and...](http://www.xda-developers.com/android/set-up-adb-and-fastboot-on-linux-mac-os-x-and-chrome-os-with-a-single-command/)

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
