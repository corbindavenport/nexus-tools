if ((Test-Path "$ENV:USERPROFILE\NexusTools") -or (Test-Path "$ENV:APPDATA\NexusTools")) {
    # Stop ADB server if it's running
    $KillServer = Start-Process "adb.exe" -ArgumentList "kill-server" -WindowStyle Hidden -Wait -PassThru
    # Nexus Tools 5.0-5.4 (Sep 2021 - May 2023) on Windows installs files in Home\NexusTools
    if (Test-Path "$ENV:USERPROFILE\NexusTools") {
        Remove-Item -Path "$ENV:USERPROFILE\NexusTools" -Recurse -Force
    }
    # Nexus Tools 5.5+ (May 2023 - Feb 2026) installs files in %AppData%\NexusTools
    if (Test-Path "$ENV:APPDATA\NexusTools") {
        Remove-Item -Path "$ENV:APPDATA\NexusTools" -Recurse -Force
    }
    # Remove Nexus Tools from Installed Apps (Add or Remove Programs) list
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\NexusTools" -Force
    # All done
    Write-Host "Done!"
}