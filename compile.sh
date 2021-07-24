# This script is for compiling the Dart executable
# The current path needs to be set to the root of the repository first
# You also need the Dart SDK and zip installed

OS=$(uname)
ARCH=$(uname -m)
FILENAME=""

if [ "$OS" = "Darwin" ]; then
    # This will need to be updated when M1 support is added
    FILENAME="nexustools-macos-x64"
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]; then
    FILENAME="nexustools-linux-x64"
elif [ "$OS" = "Linux" ] && [ "$ARCH" = "amd64" ]; then
    FILENAME="nexustools-linux-x64"
else
    FILENAME="nexustools"
fi

mkdir -p ./dist
dart compile exe "./bin/main.dart" -o "./dist/$FILENAME"
cd ./dist
zip "$FILENAME.zip" "$FILENAME"
rm "$FILENAME"
cd ../