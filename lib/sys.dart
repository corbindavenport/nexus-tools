import 'dart:io' as io;

Map envVars = io.Platform.environment;

// Function for checking if an executable is already installed
void checkIfInstalled(String dir, String command, String commandName) async {
  var info = '';
  if (io.Platform.isWindows) {
    var cmd = await io.Process.run('where', [command]);
    info = cmd.stdout.toString();
  } else {
    var cmd = await io.Process.run('which', [command]);
    info = cmd.stdout.toString();
  }
  if (info.contains(dir)) {
    // Executable is installed in the Nexus Tools directory
    return;
  } else if (info.isEmpty) {
    // Executable isn't installed at all
  } else {
    // Executable is installed but not inside the Nexus Tools directory
    var location = info.replaceAll('\n', '');
    print('[EROR] $commandName is already installed at $location. Please uninstall $commandName and try again.');
    io.exit(1);
  }
}

// Function get current CPU architecture
Future<String> getCPUArchitecture() async {
  if (io.Platform.isWindows) {
    var cpu = envVars['PROCESSOR_ARCHITECTURE'];
    return cpu;
  } else {
    var info = await io.Process.run('uname', ['-m']);
    var cpu = info.stdout.toString().replaceAll('\n', '');
    return cpu;
  }
}

// Function for adding a directory to the system/shell $PATH
Future addPath(String path) async {
  if (envVars['PATH'].toString().contains(path)) {
    // Directory is already in $PATH
    print('[ OK ] $path is already in PATH.');
  } else {
    // Directory needs to be added to $PATH
    if (io.Platform.isWindows) {
      var newPath = envVars['PATH'].toString() + '$path';
      await io.Process.run('setx', ['path', newPath]);
      print('[ OK ] Added $path to user %PATH.');
    } else if (envVars['SHELL'].toString().contains('zsh')) {
      // Z Shell
      var file = io.File(envVars['HOME'] + '/.zshrc');
      await file.writeAsString('\nexport PATH=\$PATH:$path', mode: io.FileMode.append);
      print('[ OK ] Z Shell detected, added $path to ' + file.path);
    } else if (envVars['SHELL'].toString().contains('bash')) {
      // Bash
      var file = io.File(envVars['HOME'] + '/.bash_profile');
      await file.writeAsString('\nexport PATH=\$PATH:$path', mode: io.FileMode.append);
      print('[ OK ] Bash Shell detected, added $path to ' + file.path);
    } else {
      print('[WARN] Shell could not be detected, you will need to manually add $path to your PATH.');
    }
  }
}

// Function for opening a web page in the default browser
void openWebpage(String url) async {
  var isWSL = await io.Directory('/mnt/c/Windows').exists();
  if (isWSL) {
    await io.Process.run('/mnt/c/Windows/explorer.exe', [url]);
  } else if (io.Platform.isWindows) {
    await io.Process.run('explorer', [url]);
  } else if (io.Platform.isMacOS) {
    await io.Process.run('open', [url]);
  } else if (io.Platform.isLinux) {
    await io.Process.run('xdg-open', [url]);
  }
}