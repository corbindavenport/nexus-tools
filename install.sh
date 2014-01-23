#!/bin/bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


cond() {
    if [ "$1" ] ; then
        echo "$2"
    else
        echo "$3"
    fi
}
info() {
    printf "\n[INFO] $*\n"
    return 0
}
okay() {
    printf "\n\033[32m[ OK ] $*\033[00m\n"
    return 0
}
warn() {
    printf "\n\033[31m[WARN] $*\033[00m"
    return 1
}

SYSTEM=$(uname -s)
OS=$(cond '$SYSTEM == "Darwin"' 'macosx' 'linux')
OS_STRING=$(cond '$OS == "macosx"' 'Mac OS X' 'Linux')

info "Nexus Tools Installer 1.0"

if [ -n "$COMSPEC" -a -x "$COMSPEC" ]; then
    warn "Nexus Tools Installer currently not compatible with Cygwin. Now exiting."
    exit
else
    if [ $(whoami) == "root" ]; then
        okay "Alright, we've got sudo. We can now write files to /usr/bin"
    else
        warn "Please run the script with sudo so we can files to /usr/bin"
        exit
    fi
fi

cd /usr/bin/

info "Downloading ADB for ${OS_STRING}..."
sudo curl -s -o adb "http://github.com/corbindavenport/nexus-tools/blob/master/${OS}/adb?raw=true" -LOk
okay "ADB finished downloading."

info "Downloading Fastboot for ${OS_STRING}..."
sudo curl -s -o fastboot "http://github.com/corbindavenport/nexus-tools/blob/master/${OS}/fastboot?raw=true" -LOk
okay "Fastboot finished downloading."

info "Making ADB and Fastboot executable..."
sudo chmod +x ./adb
sudo chmod +x ./fastboot
okay "Done!"

info "Type adb or fastboot to run."
