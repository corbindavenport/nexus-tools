# This script is just a wrapper to start the Dart executable from the GitHub releases page.

$Dir = "$Home\NexusTools"
$Arch = $ENV:Processor_Architecture
$BaseUrl = "https://github.com/corbindavenport/nexus-tools"
$Download = "$BaseUrl/releases/latest/download/nexustools-windows-x64.zip"

# Make the new directory
$dirCheck = Test-Path "$Dir"
if ($dirCheck) {
    # Do nothing
} else {
    # Create folder and hide output
    New-Item "$Dir" -ItemType Directory -ea 0 | Out-Null
}

# Start Dart executable
Invoke-WebRequest -Uri "$Download" -OutFile "$Dir\temp.zip"
Expand-Archive -LiteralPath "$Dir\temp.zip" -DestinationPath "$Dir" -Force
del "$Dir\temp.zip"
& "$Dir\nexustools.exe" -i -w
