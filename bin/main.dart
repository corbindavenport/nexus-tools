import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:archive/archive.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:nexustools/sys.dart' as sys;

String macZip =
    'https://dl.google.com/android/repository/e8b2b4cbe47c728c1e54c5f524440b52d4e1a33c.platform-tools_r31.0.3-darwin.zip';
String linuxZip =
    'https://dl.google.com/android/repository/platform-tools_r31.0.3-linux.zip';
String windowsZip =
    'https://dl.google.com/android/repository/platform-tools_r31.0.3-windows.zip';
List supportedCPUs = ['amd64', 'x86_64', 'AMD64'];
Map envVars = io.Platform.environment;
double appVersion = 5.4;

// Function for checking for update
Future checkUpdate() async {
  var net = Uri.parse(
      'https://api.github.com/repos/corbindavenport/nexus-tools/releases/latest');
  try {
    var data = await http.read(net);
    var parsedData = json.decode(data);
    // Compare versions
    if (double.parse(parsedData['tag_name']) > appVersion) {
      print(
          '[INFO] Nexus Tools update available! Download: https://git.io/JBuTh');
    } else {
      print('[INFO] You have the latest version of Nexus Tools.');
    }
  } catch (e) {
    print('[EROR] Could not check for updates.');
  }
}

// Function for obtaining Nexus Tools path
// Credit: https://stackoverflow.com/a/25498458
String nexusToolsDir() {
  var home = '';
  if (io.Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (io.Platform.isLinux) {
    home = envVars['HOME'];
  } else if (io.Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  if (home.endsWith('/')) {
    home = home.substring(0, home.length - 1);
  }
  if (io.Platform.isWindows) {
    return '$home\\NexusTools';
  } else {
    return '$home/.nexustools';
  }
}

// Function for installing Platform Tools package
Future installPlatformTools() async {
  var dir = nexusToolsDir();
  // Get the proper ZIP file
  var zip = '';
  if (io.Platform.isMacOS) {
    zip = macZip;
  } else if (io.Platform.isLinux) {
    zip = linuxZip;
  } else if (io.Platform.isWindows) {
    zip = windowsZip;
  }
  // Download file
  print('[....] Downloading Platform Tools package, please wait.');
  var net = Uri.parse(zip);
  try {
    var data = await http.readBytes(net);
    var archive = ZipDecoder().decodeBytes(data);
    extractArchiveToDisk(archive, dir);
  } catch (e) {
    var error = e.toString();
    print('[EROR] There was an error downloading Platform Tools: $error');
    io.exit(1);
  }
  // Move files out of platform-tools subdirectory and delete the subdirectory
  if (io.Platform.isWindows) {
    await io.Process.run('move', ['$dir\\platform-tools\\*', '$dir'],
        runInShell: true);
    await io.Process.run('rmdir', ['/Q', '/S', '$dir\\platform-tools'],
        runInShell: true);
  } else {
    await io.Process.run(
        '/bin/sh', ['-c', 'mv -f -v $dir/platform-tools/* $dir/']);
    await io.Process.run('/bin/sh', ['-c', 'rm -rf $dir/platform-tools']);
  }
  // Mark binaries in directory as executable
  if (io.Platform.isLinux || io.Platform.isMacOS) {
    await io.Process.run('/bin/sh', ['-c', 'chmod -f +x $dir/*']);
  }
  // Give a progress report
  print('[ OK ] Platform Tools now installed in $dir.');
  // Add binaries to path
  await sys.addPath(dir);
  // Create help link
  if (io.Platform.isWindows) {
    var file = io.File('$dir\\About Nexus Tools.url');
    await file.writeAsString(
        '[InternetShortcut]\nURL=https://github.com/corbindavenport/nexus-tools/blob/master/README.md',
        mode: io.FileMode.writeOnly);
  } else if (io.Platform.isMacOS) {
    var file = io.File('$dir/About Nexus Tools.url');
    await file.writeAsString(
        '[InternetShortcut]\nURL=https://github.com/corbindavenport/nexus-tools/blob/master/README.md',
        mode: io.FileMode.writeOnly);
  } else if (io.Platform.isLinux) {
    var file = io.File('$dir/About Nexus Tools.desktop');
    await file.writeAsString(
        '[Desktop Entry]\nEncoding=UTF-8\nIcon=text-html\nType=Link\nName=About Nexus Tools\nURL=https://github.com/corbindavenport/nexus-tools/blob/master/README.md',
        mode: io.FileMode.writeOnly);
  }
  // Install drivers on Windows
  if (io.Platform.isWindows) {
    // Check if Universal Adb Driver package is already installed
    var info = await io.Process.run('wmic', ['product', 'get', 'Name']);
    var parsedInfo = info.stdout.toString();
    if (parsedInfo.contains('Universal Adb Driver')) {
      print('[ OK ] Universal ADB Drivers already installed.');
    } else {
      // Prompt to install drivers
      print(
          '[WARN] Drivers may be required for ADB if they are not already installed.');
      io.stdout
          .write('[WARN] Install drivers from adb.clockworkmod.com? [Y/N] ');
      var input = io.stdin.readLineSync();
      if (input?.toLowerCase() == 'y') {
        await installWindowsDrivers(dir);
      }
    }
  }
}

// Function for removing Platform Tools package
Future removePlatformTools() async {
  // Nexus Tools 3.2+ (August 2016-Present) installs binaries in ~/.nexustools
  var dir = nexusToolsDir();
  var installExists = false;
  installExists = await io.Directory(dir).exists();
  if (installExists) {
    print(
        '[WARN] Deleting $dir will delete Android System Tools (ADB, Fastboot, etc.).');
    print('[WARN] This will also delete the Nexus Tools application.');
    io.stdout.write('[WARN] Continue with removal? [Y/N] ');
    var input = io.stdin.readLineSync();
    if (input?.toLowerCase() != 'y') {
      return;
    }
    // Proceed with deletion
    await io.Directory(dir).delete(recursive: true);
    print('[ OK ] Deleted directory at $dir.');
    print('[INFO] Nexus Tools can be re-installed at https://git.io/JBuTh.');
  } else {
    print('[EROR] No installation found at $dir.');
  }
}

// Function for installing Windows Universal ADB drivers
// Drivers provided by ClockWorkMod: https://adb.clockworkmod.com/
Future installWindowsDrivers(String dir) async {
  print('[....] Downloading drivers, please wait.');
  var net = Uri.parse(
      'https://github.com/koush/adb.clockworkmod.com/releases/latest/download/UniversalAdbDriverSetup.msi');
  try {
    var data = await http.readBytes(net);
    var file = io.File('$dir\\ADB Drivers.msi');
    await file.writeAsBytes(data, mode: io.FileMode.writeOnly);
    print('[....] Opening driver installer.');
    await io.Process.run(
        'start', ['/wait', 'msiexec.exe', '/i', '$dir\\ADB Drivers.msi'],
        runInShell: true);
  } catch (e) {
    print(
        '[EROR] There was an error downloading drivers, try downloading them from adb.clockworkmod.com.');
  }
}

// Function for Plausible Analytics reporting
void connectAnalytics() async {
  var uuid = Uuid();
  var id = uuid.v4();
  // Get exact operating system
  var realOS = '';
  var isWSL = await io.Directory('/mnt/c/Windows').exists();
  var isChromeOS = await io.Directory('/usr/share/themes/CrosAdapta').exists();
  if (isWSL) {
    realOS = 'wsl';
  } else if (isChromeOS) {
    realOS = 'chromeos';
  } else {
    realOS = io.Platform.operatingSystem;
  }
  var cpu = await sys.getCPUArchitecture();
  // Set data
  var net = Uri.parse('https://plausible.io/api/event');
  var netHeaders = {
    'user-agent': 'Nexus Tools',
    'X-Forwarded-For': '127.0.0.1',
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0 ($realOS) AppleWebKit/500 (KHTML, like Gecko) Chrome/$appVersion $id'
  };
  var netBody = '{"name":"pageview","url":"app://localhost/$realOS/$cpu","domain":"nexustools.corbin.io"}';
  // Send request
  try {
    await http.post(net, headers: netHeaders, body: netBody);
  } catch (_) {
    // Do nothing
  }
}

// Pre-installation steps
Future checkInstall() async {
  // Check if directory already exists
  var dir = nexusToolsDir();
  var installExists = false;
  if (io.Platform.isWindows) {
    installExists = await io.File('$dir\\adb.exe').exists();
  } else {
    installExists = await io.File('$dir/adb').exists();
  }
  if (installExists) {
    io.stdout.write(
        '[WARN] Platform tools already installed in $dir. Continue? [Y/N] ');
    var input = io.stdin.readLineSync();
    if (input?.toLowerCase() != 'y') {
      io.exit(0);
    }
  } else {
    // Make the directory
    await io.Directory(dir).create(recursive: true);
    print('[ OK ] Created folder at $dir.');
  }
  // Check if ADB is already installed
  sys.checkIfInstalled(dir, 'adb', 'ADB');
  // Check if Fastboot is already installed
  sys.checkIfInstalled(dir, 'fastboot', 'Fastboot');
  // Check CPU architecture
  var cpu = await sys.getCPUArchitecture();
  if (supportedCPUs.contains(cpu)) {
    print('[ OK ] Your hardware platform is supported, yay!');
  } else if (io.Platform.isMacOS && (cpu == 'arm64')) {
    print(
        '[WARN] Google does not provide native Apple Silicon binaries yet, x86_64 binaries will be installed');
  } else {
    print(
        '[EROR] Your hardware platform is detected as $cpu, but Google only provides Platform Tools for x86-based platforms.');
    io.exit(1);
  }
  // Display environment-specific warnings
  var isWSL = await io.Directory('/mnt/c/Windows').exists();
  var isChromeOS = await io.Directory('/usr/share/themes/CrosAdapta').exists();
  if (isWSL) {
    print(
        '[WARN] WSL does not support USB devices, you will only be able to use ADB over Wi-Fi.');
  } else if (isChromeOS) {
    print('[WARN] Chrome OS 75 or higher is required for USB support.');
  }
}

void printHelp() {
  var helpDoc = '''
Nexus Tools $appVersion
Downloader/management app for Android SDK Platform Tools

Usage: nexustools [OPTIONS]

Example: nexustools -i (this installs Platform Tools)

 -i, --install                 Install/update Android Platform Tools
 -r, --remove                  Remove Platform Tools
 -n, --no-analytics            Run Nexus Tools without Plausible Analytics
                               (analytics is only run on install)
 -c, --check                   Check for Nexus Tools update
 -h, --help                    Display this help message
  ''';
  print(helpDoc);
}

void main(List<String> arguments) async {
  if (arguments.contains('-i') || arguments.contains('--install')) {
    print('[INFO] Nexus Tools $appVersion');
    // Check version unless Nexus Tools is running from web (curl) installer
    // The web installer adds the -w parameter
    if (!arguments.contains('-w')) {
      await checkUpdate();
    }
    // Start analytics unless opted out
    if (arguments.contains('--no-analytics')) {
      print('[ OK ] Plausible Analytics are disabled.');
    } else {
      connectAnalytics();
    }
    // Start installation
    await checkInstall();
    await installPlatformTools();
    // Post-install
    var appName = '';
    if (io.Platform.isWindows) {
      appName = 'Command Line window (not a new tab!)';
    } else {
      appName = 'Terminal window';
    }
    print(
        '[INFO] Installation complete! Open a new $appName to apply changes.');
    print('[INFO] Run "nexustools --help" at any time for more options.');
    print(
        '[INFO] Join the Discord server: https://discord.com/invite/59wfy5cNHw');
    print('[INFO] Donate to support development: https://git.io/J4jct');
  } else if (arguments.contains('-r') || arguments.contains('--remove')) {
    print('[INFO] Nexus Tools $appVersion');
    // Start removal
    await removePlatformTools();
  } else if (arguments.contains('-h') || arguments.contains('--help')) {
    printHelp();
  } else if (arguments.contains('-c') || arguments.contains('--check')) {
    await checkUpdate();
  } else {
    print('[EROR] Invalid arguments. Run nexustools -h for help!');
  }
}
