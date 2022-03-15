# Nexus Tools

Nexus Tools is an installer for the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) package, which includes [ADB](https://developer.android.com/studio/command-line/adb.html), Fastboot, and other applications. Nexus Tools is writen in Dart, and can run on Linux, macOS, Windows, Windows Subsystem for Linux, and Chrome OS.

Nexus Tools downloads the latest Platform tools package directly from Google's servers (so you're always getting the latest version), saves them to `~/.nexustools` (`$Home\NexusTools` on Windows), and adds the directory to your system's path. On Windows, Nexus Tools can optionally install [Koush's Universal ADB Driver](https://github.com/koush/UniversalAdbDriver).

Once Nexus Tools is finished, you can run `adb`, `fastboot`, and other commands with no problems. **You need to open a new terminal/command line window after installation for changes to take effect.** The SDK Platform Tools can be updated by running `nexustools -i`, or you can uninstall everything by running `nexustools -r`.

### How to use on Linux, macOS, and Chrome OS

Paste this command into the Terminal app:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh)
```

You can also download the Mac and Linux versions from the [latest release page](https://github.com/corbindavenport/nexus-tools/releases/), un-zip the file, and run it from the Terminal.

### How to use on Windows

Open Windows PowerShell from the Start Menu and paste this command:

```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.ps1'))
```

You can also download the Windows version from the [latest release page](https://github.com/corbindavenport/nexus-tools/releases/), un-zip the file, and run it from Windows PowerShell or the Command Prompt.

### Compatibility

Nexus Tools is only available for x86_64 macOS, Linux, and Windows, because Google only provides native Platform Tools binaries for those platforms. On Macs with Apple Silicon, Nexus Tools runs in the [Rosetta 2 compatibility layer](https://support.apple.com/en-us/HT211861).

### Analytics

Nexus Tools uses [Plausible Analytics](https://plausible.io) to transmit your operating system and CPU architecture during the installation process. This data is not sold or shared in any way, it's only for me to know which hardware platforms I should focus my attention on. You can disable analytics reporting by adding the `--no-analytics` parameter to the install command, like this:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/master/install.sh) --no-analytics
```

It also works when running Nexus Tools locally:

```
nexustools --no-analytics
```

This analytics data is viewable publicly at [plausible.io/nexustools.corbin.io](https://plausible.io/nexustools.corbin.io).

### Development info

Nexus Tools is written in Dart, so you need the [Dart SDK](https://dart.dev/get-dart) to work on it. You can run Nexus Tools from source like this:

```
dart ./bin/main.dart
```

The `compile.sh` (macOS and Linux) and `compile.ps1` scripts create executables and zip them. You can also use GitHub Actions to compile Nexus Tools, by navigating to Actions > Compile Nexus Tools > Run workflow.
