import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:archive/archive.dart';
import 'package:uuid/uuid.dart';
import 'package:nexustools/sys.dart' as sys;

String platform = io.Platform.operatingSystem;
String macZip = 'https://dl.google.com/android/repository/platform-tools-latest-darwin.zip';
String linuxZip = 'https://dl.google.com/android/repository/platform-tools-latest-linux.zip';
List supportedCPUs = ['i386', 'i486', 'i586', 'amd64', 'x86_64', 'i686'];

// Function for obtaining Nexus Tools path
// Credit: https://stackoverflow.com/a/25498458
String nexusToolsDir() {
  var home = '';
  Map envVars = io.Platform.environment;
  if (io.Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (io.Platform.isLinux) {
    home = envVars['HOME'];
  }
  /*else if (io.Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  */
  if (home.endsWith('/')) {
    home = home.substring(0, home.length - 1);
  }
  return '$home/.nexustools';
}

// Function for installing Platform Tools package
void installPlatformTools() async {
  var dir = nexusToolsDir();
  // Get the proper ZIP file
  var zip = '';
  if (io.Platform.isMacOS) {
    zip = macZip;
  } else if (io.Platform.isLinux) {
    zip = linuxZip;
  }
  // Download file
  print('[....] Downloading Platform Tools package...');
  var net = Uri.parse(zip);
  try {
    var data = await http.readBytes(net);
    //await zipFile.writeAsBytes(data);
    var archive = ZipDecoder().decodeBytes(data);
    extractArchiveToDisk(archive, dir);
  } catch (e) {
    var error = e.toString();
    print('[EROR] There was an error downloading Platform Tools: $error');
    io.exit(1);
  }
  // Move files out of platform-tools subdirectory
  var result = await io.Process.run('mv', ['-f', '\*', '$dir'], workingDirectory:'$dir/platform-tools/');
  //io.stdout.write(result.stdout);
  //io.stderr.write(result.stderr);
  //await io.Process.run('rmdir', ['$dir/platform-tools*']);
}

// Function for copying udex.txt to proper location
void installUdev() {
  // TODO
}

// Function for installing USB Vendor ID list
void installIni() {
  // TODO
}

// Function for adding Nexus Tools directory to $PATH
void addPath() {
  // TODO
}

// Function for Google Analytics reporting
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
    realOS = 'chrome-os';
  } else {
    realOS = io.Platform.operatingSystem;
  }
  realOS = Uri.encodeComponent(realOS);
  var cpu = await sys.getCPUArchitecture();
  // Send analytics data
  var net = Uri.parse('https://www.google-analytics.com/collect?v=1&t=pageview&tid=UA-74707662-1&cid=$id&dp=$realOS%2F$cpu');
  try {
    await http.get(net);
  } catch (_) {
    // Do nothing
  }
}

// Function for opening competion webpage
void openWebpage() {}

void main(List<String> arguments) async {
  // Start the installer
  print('[INFO] Nexus Tools 5.0');
  // Start analytics asynchronously 
  if (arguments.contains('no-analytics')) {
    print('[ OK ] Google Analytics are disabled.');
  } else {
    connectAnalytics();
  }
  // Check if directory already exists
  var dir = nexusToolsDir();
  var dirExists = await io.Directory(dir).exists();
  if (dirExists) {
    io.stdout.write('[WARN] Platform tools installed in $dir. Continue? [Y/N] ');
    var input = io.stdin.readLineSync();
    if (input?.toLowerCase() != 'y') {
      return;
    }
  } else {
    // Make the directory
    await io.Directory(dir).create(recursive: true);
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
    print('[WARN] Google doesn not provide native Apple Silicon binaries yet, x86_64 binaries will be installed');
  } else {
    print('[EROR] Your hardware platform is detected as $cpu, but Google only provides Platform Tools for x86-based platforms.');
    io.exit(1);
  }
  // Display environment-specific warnings
  var isWSL = await io.Directory('/mnt/c/Windows').exists();
  var isChromeOS = await io.Directory('/usr/share/themes/CrosAdapta').exists();
  if (isWSL) {
    print('[WARN] WSL does not support USB devices, you will only be able to use ADB over Wi-Fi.');
  } else if (isChromeOS) {
    print ('[WARN] Chrome OS 75 or higher is required for USB support.');
  }
  // Install Rosetta on macOS if needed
  if (io.Platform.isMacOS) {
    sys.checkRosetta();
  }
  // Start main installation
  installPlatformTools();
}
