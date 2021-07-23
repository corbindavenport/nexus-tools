import 'dart:io' as io;

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
    print('[EROR] $commandName is already installed at $location. Please uninstall $commandName and try again.');
    io.exit(1);
  }
}

// Function get current CPU architecture
Future<String> getCPUArchitecture() async {
  var info = await io.Process.run('uname', ['-m']);
  var cpu = info.stdout.toString().replaceAll('\n', '');
  return cpu;
}

// Function to verify Rosetta compatibility layer is enabled on ARM macOS
void checkRosetta() async {
  var cpu = await getCPUArchitecture();
  var rosettaInstalled = await io.Directory('/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist').exists();
  if (io.Platform.isMacOS && (cpu == 'arm64')) {
    if (rosettaInstalled) {
      print('[ OK ] Rosetta compatibility layer is already installed.');
    } else {
      io.stdout.write('[WARN] Apple Rosetta compatibility layer must be installed. Continue? [Y/N] ');
      var input = io.stdin.readLineSync();
      if (input?.toLowerCase() != 'y') {
        print('[ .. ] Please wait while Rosetta is installed...');
        await io.Process.run('/usr/sbin/softwareupdate', ['---install-rosetta', '--agree-to-license']);
      } else {
        io.exit(1);
      }
    }
  }
}