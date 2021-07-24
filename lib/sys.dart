import 'dart:io' as io;

Map envVars = io.Platform.environment;

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

// Function get current CPU architecture
Future<String> getCPUArchitecture() async {
  var info = await io.Process.run('uname', ['-m']);
  var cpu = info.stdout.toString().replaceAll('\n', '');
  return cpu;
}

// Function for adding a directory to the system/shell $PATH
void addPath(String path) async {
  if (envVars['PATH'].toString().contains(path)) {
    // Directory is already in $PATH
    print('[ OK ] $path is already in PATH.');
  } else {
    // Directory needs to be added to $PATH
    if (envVars['SHELL'].toString().contains('zsh')) {
      // Z Shell
      var file = io.File(envVars['HOME'] + '/.zshrc');
      await file.writeAsString('export PATH=$path:', mode: io.FileMode.append);
      print('[ OK ] Z Shell detected, added $path to ' + file.path);
    } else if (envVars['SHELL'].toString().contains('bash')) {
      // Bash
      var file = io.File(envVars['HOME'] + '/.bashrc');
      await file.writeAsString('export PATH=$path:', mode: io.FileMode.append);
      print('[ OK ] Bash Shell detected, added $path to ' + file.path);
    } else {
      print('[WARN] Shell could not be detected, you will need to manually add $path to your PATH.');
    }
  }
}

// Function for opening a web page in the default browser asyncronously
void openWebpage(String url) async {
  var isWSL = await io.Directory('/mnt/c/Windows').exists();
  if (isWSL) {
    await io.Process.run('/mnt/c/Windows/explorer.exe', ['https://corbin.io/nexus-tools-exit.html']);
  } else if (io.Platform.isMacOS) {
    await io.Process.run('open', ['https://corbin.io/nexus-tools-exit.html']);
  } else if (io.Platform.isLinux) {
    await io.Process.run('xdg-open', ['https://corbin.io/nexus-tools-exit.html']);
  }
}