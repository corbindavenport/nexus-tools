$FileName = "nexustools-windows-x64"

# Make the new directory
$dirCheck = Test-Path dist
if ($dirCheck) {
    # Do nothing
} else {
    New-Item -Name "dist" -ItemType Directory
}

dart compile exe "./bin/main.dart" -o "./dist/nexustools.exe"
Compress-Archive -Path "./dist/nexustools.exe" -DestinationPath "./dist/$FileName.zip" -Force
del "./dist/nexustools.exe"