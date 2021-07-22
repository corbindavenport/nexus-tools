import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:uuid/uuid.dart';

String platform = io.Platform.operatingSystem;
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

// Function for checking if an executable is already installed
void checkIfInstalled(String dir, String command, String commandName) async {
  var info = await io.Process.run('which', [command]);
  if (info.stdout.toString().contains(dir)) {
    // Executable is installed in the Nexus Tools directory
    return;
  } else if (info.stdout.toString().isEmpty) {
    // Executable isn't installed at all
  } else {
    // Executable is installed but not inside the Nexus Tools directory
    var location = info.stdout.toString().replaceAll('\n', '');
    print(
        '[EROR] $commandName is already installed at $location. Please uninstall $commandName and try again.');
    io.exit(1);
  }
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

// Function get current CPU architecture
Future<String> getCPUArchitecture() async {
  var info = await io.Process.run('uname', ['-m']);
  var cpu = info.stdout.toString().replaceAll('\n', '');
  return cpu;
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
  var cpu = await getCPUArchitecture();
  // Send analytics data
  var net = Uri.parse(
      'https://www.google-analytics.com/collect?v=1&t=pageview&tid=UA-74707662-1&cid=$id&dp=$realOS%2F$cpu');
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
  // Start analytics
  if (arguments.contains('no-analytics')) {
    print('[ OK ] Google Analytics are disabled.');
  } else {
    connectAnalytics();
  }
  // Check if directory already exists
  var dir = nexusToolsDir();
  var dirExists = await io.Directory(dir).exists();
  if (dirExists) {
    io.stdout
        .write('[WARN] Platform tools installed in $dir. Continue? [Y/N] ');
    var input = io.stdin.readLineSync();
    if (input?.toLowerCase() != 'y') {
      return;
    }
  } else {
    // Make the directory
    await io.Directory(dir).create(recursive: true);
  }
  // Check if ADB is already installed
  checkIfInstalled(dir, 'adb', 'ADB');
  // Check if Fastboot is already installed
  checkIfInstalled(dir, 'fastboot', 'Fastboot');
  // Proceed with installation
  var cpu = await getCPUArchitecture();
  if (supportedCPUs.contains(cpu)) {
    print('[ OK ] Your hardware platform is supported, yay!');
  } else if (io.Platform.isMacOS && (cpu == 'arm64')) {
    print(
        '[WARN] Google doesn not provide native Apple Silicon binaries yet, x86_64 binaries will be installed');
  } else {
    print(
        '[EROR] Your hardware platform is detected as $cpu, but Google only provides Platform Tools for x86-based platforms.');
    io.exit(1);
  }
}
