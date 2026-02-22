# This script only exists to avoid breaking guides and tutorials that include Nexus Tools.

# Show discontinued message

Write-Host "`nNexus Tools is now discontinued.`n`nYou can install ADB and Fastboot with Winget, using this command:`nwinget install -e --id Google.PlatformTools"

# Ask user to remove existing installation
if ((Test-Path "$ENV:USERPROFILE\NexusTools") -or (Test-Path "$ENV:APPDATA\NexusTools")) {
    Write-Host "`n==========`n`nADB and Fastboot have already been installed with Nexus Tools. You should delete them before installing with another method."
    $confirmation = Read-Host "Delete Nexus Tools installation? [Y/N]"
    if ($confirmation -eq 'y') {
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
}

Write-Host ""