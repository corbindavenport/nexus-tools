# Nexus Tools

Nexus Tools is an installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) package, which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, and other applications. Nexus Tools is writen in Dart, and can run on Linux, macOS, Windows, Windows Subsystem for Linux, and Chrome OS.

Nexus Tools downloads the latest Platform tools package directly from Google's servers (so you're always getting the latest version), saves them to `~/.nexustools`, and adds the directory to your system's path. On Windows, Nexus Tools can optionally install [Koush's Universal ADB Driver](https://github.com/koush/UniversalAdbDriver).

Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands straight from the terminal. **You need to open a new terminal/command line window for changes to take effect.** To update, just run Nexus Tools again.

### How to use on Linux, macOS, and Chrome OS

Paste this command into the Terminal app:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```

To uninstall, run this command:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/uninstall.sh)
```

You can also download the Mac and Linux versions from the [latest release page](https://github.com/corbindavenport/nexus-tools/releases/), un-zip the file, and run it from the Terminal.

### How to use on Windows

Download the Windows application from the [latest release page](https://github.com/corbindavenport/nexus-tools/releases/), and un-zip the file somewhere. Then run the executable in CMD.EXE or PowerShell.

Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands straight from the terminal. **You may need to open a new terminal window for changes to take effect.** To update, just run the installer again.

### Compatibility

Nexus Tools is only available for x86 macOS, Linux, and Windows, because Google only provides native Platform Tools binaries for those platforms. On Macs with Apple Silicon, Nexus Tools runs in the [Rosetta 2 compatibility layer](https://support.apple.com/en-us/HT211861).

### Analytics

Nexus Tools uses Google Analytics to transmit your operating system and CPU architecture during the installation process. This data is not sold or shared in any way, it's only for me to know which hardware platforms I should focus my attention on. You can disable Google Analytics by adding the `no-analytics` parameter to the install command, like this:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh) --no-analytics
```

It also works when running Nexus Tools locally:

```
nexustools --no-analytics
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
