# Nexus Tools

Nexus Tools was an installer and updater for [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools). Nexus Tools is now discontinued, and the installation commands now walk you through alternative methods of installing ADB, Fastboot, and other Platform Tools. This is intended to avoid completely breaking tutorials and articles that referenced Nexus Tools.

On macOS, the installation command prompts the user to install the [Brew package manager](https://brew.sh/) if it's not already installed, then installs the [android-platform-tools cask](https://formulae.brew.sh/cask/android-platform-tools).

### How to use on Linux, macOS, and Chrome OS

Paste this command into your Terminal app:

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/install.sh)
```

### How to use on Windows

Open Windows PowerShell from the Start Menu and paste this command:

```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/install.ps1'))
```