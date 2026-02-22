Nexus Tools has been discontinued. If you used Nexus Tools, you should delete its installation directory, then install ADB and Fastboot with another method.

**Remove Nexus Tools on Mac and Linux:**

```
bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/uninstall.sh)
```

**Remove Nexus Tools on Windows:**
```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/uninstall.ps1'))
```

## Install ADB and Fastboot on Windows

You can use Winget to install ADB and Fastboot:

```
winget install -e --id Google.PlatformTools
```

Winget should be included in your Windows installation. If not, [download it from the Microsoft Store](https://apps.microsoft.com/detail/9nblggh4nns1).

## Install ADB and Fastboot on Mac

You can install the [Brew package manager](https://brew.sh/), then run the below command to install ADB and Fastboot:

```
brew install --cask android-platform-tools
```

## Install ADB and Fastboot on Linux

Most Linux distributions have updated versions of ADB, Fastboot, and other Android Platform Tools in their software repositories.

**Ubuntu, Debian, Pop!_OS, Linux Mint, and other distributions based on Ubuntu or Debian:**

```
sudo apt install android-sdk-platform-tools
```

**Fedora and Fedora-based distributions:**

```
dnf install android-tools
```

**Arch Linux or Arch-based distributions:**

```
pacman -S android-tools
```

You can also try installing the [Brew package manager](https://brew.sh/), then installing Platform Tools through Brew:

```
brew install --cask android-platform-tools
```
