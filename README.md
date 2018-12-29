![Nexus Tools logo](https://i.imgur.com/2l38Zqb.png)
================

Nexus Tools is a simple installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) package, which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, [Systrace](https://developer.android.com/studio/profile/systrace-commandline.html), and other applications.

Installing these tools requires downloading the proper zip file, extracting it somewhere, and [adding the folder to your system's path](https://askubuntu.com/a/60221). Nexus Tools does all that hard work for you, and installs additional configuration files to fix common USB problems.

### Features

* The SDK Platform Tools package is downloaded from Google's servers, so you're always getting the latest version.
* All files are stored in `~/.nexustools`, so sudo access is not required.
* A [USB Vendor ID list](https://apkudo.com/one-true-adb_usb-ini-to-rule-them-all/) and [UDEV rules file](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules) are installed to fix common USB connection issues (UDEV file only applies to Linux and is optional).
* Works on Linux, Bash for Windows 10 ([without USB support](https://github.com/Microsoft/WSL/issues/2195)), Linux on Chromebooks ([again, without USB support](https://www.aboutchromebooks.com/news/project-crostini-linux-usb-support-chromebooks/)), and Mac.

### How to install

Nexus Tools does not need to be downloaded, just paste this command into the terminal:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```
To uninstall, run this command:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/uninstall.sh)
```

Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands straight from the terminal. **You may need to open a new terminal window for changes to take effect.** To update, just run the installer again.

[XDA thread for Nexus Tools](http://forum.xda-developers.com/general/general/tool-nexus-tools-2-8-featured-xda-t3258661)

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
