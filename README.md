![Nexus Tools logo](https://i.imgur.com/2l38Zqb.png)
================

Nexus Tools is a simple installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools), which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, [Systrace](https://developer.android.com/studio/profile/systrace-commandline.html), and other applications.

The tools are downloaded directly from Google's servers during installation, so you're always getting the latest available versions. On Linux, [a UDEV rules list](https://github.com/M0Rf30/android-udev-rules) can optionally be installed, to ensure there are no issues with USB devices.

### Supported platforms

* Mac OS X / macOS
* Linux (x86/x86_64 only)
* Bash on Windows 10 ([USB connections do not work](https://github.com/Microsoft/WSL/issues/2195))

[Chrome OS may also work](https://github.com/corbindavenport/nexus-tools/wiki/Chrome-OS-Help), but it is currently unsupported.

### Install instructions

The installer does not need to be downloaded, just paste this command into the terminal:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```
To uninstall, run this command:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/uninstall.sh)
```

Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands straight from the terminal. To update, just run the installer again.

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
