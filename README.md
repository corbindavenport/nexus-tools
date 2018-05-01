![Nexus Tools logo](https://i.imgur.com/2l38Zqb.png)
================

Nexus Tools is a simple installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools), which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, [Systrace](https://developer.android.com/studio/profile/systrace-commandline.html), and other applications. These are commonly used for Android development and device modding. __Nexus Tools works on both macOS and Linux.__

The installer does not need to be downloaded, just paste this command into the terminal:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```
To uninstall, run this command:
```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/uninstall.sh)
```

The applications are downloaded directly from Google's servers during installation, so you're always getting the latest available versions. Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands straight from the terminal. To update, just run the installer again.

__Note for Linux users:__ Nexus Tools should work on all Linux distros that use Bash shell. Only x86/x86_64 platforms are supported.

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
