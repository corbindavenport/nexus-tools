# Nexus Tools

Nexus Tools is a simple installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) package, which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, [Systrace](https://developer.android.com/studio/profile/systrace-commandline.html), and other applications.

Installing these tools requires downloading the proper files, extracting them somewhere, and [adding the files' folder to your system's path](https://askubuntu.com/a/60221). Nexus Tools does all that hard work for you, and installs additional configuration files to fix common USB problems.

### Features

* Works on Linux, Bash for Windows 10¹, Linux on Chromebooks², and Mac. An x86 processor is required on all platforms.
* The SDK Platform Tools package is downloaded from Google's servers, so you're always getting the latest version.
* All files are stored in `~/.nexustools`, so sudo access is not required.
* A [USB Vendor ID list](https://apkudo.com/one-true-adb_usb-ini-to-rule-them-all/) and [UDEV rules file](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules) are installed to fix common USB connection issues (UDEV file only applies to Linux and is optional).
* Can be easily removed.

¹*Windows Subsystem for Linux doesn't support USB connections. However, it is possible to use ADB over a Wi-Fi connection using a [third-party app](https://play.google.com/store/apps/details?id=com.ttxapps.wifiadb) or [Android 11+](https://www.androidpolice.com/2020/03/18/android-11-developer-preview-2-fully-supports-wireless-adb/).*

²*Chrome OS 75 or newer is required for [USB support](https://www.androidpolice.com/2019/06/26/chrome-os-75/).*

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

### Analytics

Nexus Tools uses Google Analytics to transmit your operating system and CPU architecture during the installation process. This data is not sold or shared in any way, it's only for me to know which hardware platforms I should focus my attention on. You can disable this by downloading the installation script, deleting everything in the `_analytics()` function, and running the modified script.

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
