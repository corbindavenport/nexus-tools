import 'package:http/http.dart' as http;
import 'dart:io' as io;

String platform = io.Platform.operatingSystem;

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
void connectAnalytics() {
  // TODO
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
  try {
    var adb = await io.Process.run('whereis', ['adb']);
    if (adb.stdout.toString().contains('.nexustools')) {
      // ADB is installed in the right directory
      return;
    } else {
      print(
          '[EROR] ADB is already installed and Nexus Tools cannot remove it automatically. Please uninstall ADB and try again.');
    }
  } catch (e) {
    // ADB is not installed, do nothing
  }
  // Check if Fastboot is already installed
  try {
    var fastboot = await io.Process.run('whereis', ['fastboot']);
    if (fastboot.stdout.toString().contains('.nexustools')) {
      // ADB is installed in the right directory
      return;
    } else {
      print(
          '[EROR] Fastboot is already installed and Nexus Tools cannot remove it automatically. Please uninstall ADB and try again.');
    }
  } catch (e) {
    // ADB is not installed, do nothing
  }
  // TODO: Do the installation
}
