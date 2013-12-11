nexus-tools
===========

Nexus Tools is an installer for the Android debug/development command-line tools ADB (Android Device Bridge) and Fastboot. The script does not need to be downloaded, simply copy and paste this command into the terminal and run it:
```
bash <(curl https://raw.github.com/corbindavenport/nexus-tools/master/install.sh)
```
This will download the script and run it. The script will download the files it needs during runtime, so it requires an internet connection. The script works on both Mac OS X and Linux (as long as the curl package is installed).

Nexus Tools requires sudo privileges to install the adb and fastboot tools to /usr/bin.
