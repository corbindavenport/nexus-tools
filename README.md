# Nexus Tools

Nexus Tools is a simple installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) package, which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, [Systrace](https://developer.android.com/studio/profile/systrace-commandline.html), and other applications.

Nexus Tools downloads the latest Platform tools package directly from Google's servers (so you're always getting the latest version), saves them to `~/.nexustools`, and adds the directory to your system's path. The installer also downloads a [USB Vendor ID list](https://apkudo.com/one-true-adb_usb-ini-to-rule-them-all/) and [UDEV rules file](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules) to fix common USB connection issues.

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

### Compatibility

|  | Compatible | Architectures | Notes |
--- | --- | --- | ---
| **Linux** | Yes | x86 | - |
| **macOS** | Yes | x86, Apple Silicon | Platform tools run in [Rosetta 2 compatibility layer](https://support.apple.com/en-us/HT211861)) on Apple Silicon Macs, because Google doesn't provide native ARM binaries yet. |
| **Windows** | Yes | x86 | You have to run Nexus Tools in the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10). WSL doesn't support USB connections, but it is possible to use ADB over a Wi-Fi connection using a [third-party app](https://play.google.com/store/apps/details?id=com.ttxapps.wifiadb) or [Android 11+](https://www.androidpolice.com/2020/03/18/android-11-developer-preview-2-fully-supports-wireless-adb/). |
| **Chrome OS** | Yes | x86 | Chrome OS 75 or newer is required for [USB support](https://www.androidpolice.com/2019/06/26/chrome-os-75/). |

### Analytics

Nexus Tools uses Google Analytics to transmit your operating system and CPU architecture during the installation process. This data is not sold or shared in any way, it's only for me to know which hardware platforms I should focus my attention on. You can disable Google Analytics by adding the `no-analytics` parameter to the install command, like this:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh) no-analytics
```

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
